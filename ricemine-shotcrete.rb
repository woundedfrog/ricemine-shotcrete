require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'redcarpet'
require 'yaml'
require 'fileutils'
require 'bcrypt'
require 'pry'
require 'zip' # allows for zipping files
require 'pg'

configure do
  set :erb, escape_html: true
end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

def disconnect
  @data.close
end

def reload_db
  # @data = PG.connect(dbname: "jpdestinydb")
   @data = PG.connect(dbname: "jpdcdb")
end

helpers do
  def long_stat_key?(key)
    %w[leader auto tap slide drive notes date].include?(key.to_s)
  end

  def short_stat_key?(key)
    %w[tier stars type element].include?(key.to_s)
  end

  def special_key?(key)
    %w[pic pic1 pic2 pic3 index].include?(key.to_s)
  end
  def get_img_link(name)
  # this gets the full-size image for a link and send placeholder if not found.
    # ../../../images/full_size/full<%= @name.gsub(/\s+/, "")
    name = 'full' + name.gsub(/\s+/, "")
    path = "./public/images/full_size/#{name}.png"
    if File.exist?(path)
      return "/images/full_size/#{name}.png"
    else
      return "/images/full_size/fullmissingpic.png"
    end

  end

  def check_if_any?(idx, tier, units)
    sub_arr = units.map do |arr|
      arr[6].split(" ")[idx]
    end
    sub_arr.any? {|rank| rank == tier }
  end

  def hide_or_show(category)
    if category == "PVE"
      return ""
    end
    "hide-list"
  end

  def split_sc_stat(stat, part)
    stat.split(" ")[part]
  end
end

def create_file_from_upload(uploaded_file, pic_param, directory)
  if !uploaded_file.nil?
    (tmpfile = uploaded_file[:tempfile]) && (pname = uploaded_file[:filename])
    path = File.join(directory, pname)
    File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  elsif pic_param.empty?
    pname = 'emptyunit0.png'
  else
    pname = pic_param
  end

  directory.gsub!('public', '')
  pname.include?(directory) ? pname : "#{directory}/" + pname
end

def load_unit_details
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/unit_details.yml', __dir__)
              else
                File.expand_path("data/unit_details.yml", __dir__)
              end
  YAML.load_file(unit_list)
end

def format_stat(stat_key, info_val)
  if %w[water fire earth light dark].include?(info_val)
    "<img class=\'element-type-pic\' src='/images/stats/#{info_val}.png' alt='#{info_val}'/>"
  elsif %w[tank attacker buffer healer debuffer].include?(info_val)
    "<img class=\'element-type-pic\' src='/images/stats/#{info_val}.png' alt='#{info_val}'/>"
  elsif stat_key == 'stars'
    "<img class=\'star_rating\' src='/images/stats/star#{info_val}.png' alt='#{info_val}'stars/>"
  else
    info_val
  end
end

def upcase_name(name)
  name.split(' ').map(&:capitalize).join(' ')
end


#### routes ####

get '/' do
  db = reload_db
  # binding.pry

  unit_data = db.exec("SELECT units.id, name, type, element, stars, pic1 FROM (SELECT * FROM units
  units ORDER BY created_on DESC LIMIT 5) as units
  RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id ORDER BY created_on ASC LIMIT 5;")
# binding.pry
  @unit = unit_data.values

  sc_data = db.exec("SELECT name, pic1, stars
    FROM (SELECT * FROM soulcards WHERE enabled = true ORDER BY created_on DESC LIMIT 4) as soulcards
    RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
    ORDER BY created_on ASC LIMIT 4;")
# binding.pry
  @unit = unit_data.values
  @soulcards = sc_data.values
  erb :home
end

get '/compare' do
db = reload_db
info = db.exec("SELECT units.id, name, stars FROM units
  RIGHT OUTER JOIN mainstats ON units.id = unit_id
  WHERE stars = '5' OR stars = '4' ORDER BY name ASC;")
  @names = info.values
  erb :compare_search
end

get '/search-results/:category/:keywords' do
  keys = params[:keywords].downcase.split(" ")
  if params[:category] == "units"
    category = 'units'
  else
    category = 'skills'
  end
  db = reload_db

  found_units = []
    found_sc = []
  if category == 'units'
    keys.each do |keyword|
      unit_data = db.exec("SELECT units.id, name, type, element, stars, pic1 FROM units
      RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
      RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id WHERE name LIKE '%#{keyword}%' ORDER BY name DESC;")
      found_units << unit_data.values

      sc_data = db.exec("SELECT name, pic1, stars
        FROM (SELECT * FROM soulcards WHERE enabled = true) as soulcards
        RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
        WHERE name LIKE '%#{keyword}%'
        ORDER BY name DESC;")
          found_sc << sc_data.values
    end
    # binding.pry
  else
    keys.each do |keyword|
      unit_data = db.exec("SELECT units.id, name, type, element, stars, pic1 FROM units
      RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
      RIGHT OUTER JOIN substats ON substats.unit_id = units.id
      RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
      WHERE slide LIKE '%#{keyword}%' OR drive LIKE '%#{keyword}%' OR notes LIKE '#{keyword}%'
      ORDER BY name DESC;")
      found_units << unit_data.values

      sc_data = db.exec("SELECT name, pic1, stars, ability
        FROM (SELECT * FROM soulcards WHERE enabled = true) as soulcards
        RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
        WHERE ability LIKE '%#{keyword}%'
        ORDER BY name DESC;")
          found_sc << sc_data.values
    end
  end

  @unit = found_units.flatten(1)
  @soulcards = found_sc.flatten(1)
  erb :search_results
end

get '/tiers/:stars' do
  # @unit = load_unit_details
  stars = params[:stars]
  redirect "/" if !['3','4','5'].include?(stars)
  db = reload_db
  # binding.pry
  unit_data = db.exec("SELECT units.id, name, type, element, stars, pic1, tier FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id where stars = '#{stars}' ORDER BY name ASC;")

  @tiers = %w(10 9 8 7 6 5 4 3 2 1)
  @sorted_by = %w(PVE PVP RAID WORLDBOSS)
  @unit = unit_data.values
  erb :child_tiers
end

get '/soulcards' do
  redirect '/soulcards/5'
  # db = reload_db
  # sc_data = db.exec("SELECT name, pic1 FROM soulcards
  #   RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
  #   WHERE enabled = true ORDER BY name ASC;")
  #
  # # x=File.expand_path("data/soul_cards.yml", __dir__)
  # # y = YAML.load_file(x)
  # @soulcards = sc_data.values
  # erb :soulcard_index
end

get '/soulcards/:stars/:name' do
    db = reload_db
    name = params[:name].gsub("'", "''")
  sc_data = db.exec("SELECT name, pic1, stars, normalstat1, normalstat2, prismstat1, prismstat2, restriction, ability FROM soulcards
    RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
    WHERE name = '#{name}';")
  @soulcard = sc_data.values
  erb :view_sc
end

get '/soulcards/:stars' do
  # @unit = load_unit_details
  stars = params[:stars]
  redirect "/soulcards/5" if !['3','4','5'].include?(stars)
  db = reload_db
  # binding.pry
  sc_data = db.exec("SELECT name, pic1, stars FROM soulcards
    RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
  WHERE stars = '#{stars}' AND enabled = true ORDER BY name ASC;")

  @soulcards = sc_data.values
  erb :soulcard_index
end

get '/sort/:stars/:sorting' do
  order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
  stars = params[:stars]
  sorting = params[:sorting]

  db = reload_db
  @sorted_by = if sorting == 'element'
                  ['water', 'fire', 'earth', 'light', 'dark']
                elsif sorting == 'type'
                  ['attacker', 'healer', 'debuffer', 'buffer', 'tank']
                elsif sorting == 'date'
                  db.exec("select distinct(created_on) as date from units
                  RIGHT OUTER JOIN mainstats on unit_id = units.id
                  where stars = '#{stars}' ORDER BY date DESC;").values.flatten(1)
                end

  data = db.exec("SELECT units.id, name, type, element, stars, pic1, created_on AS date FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id where stars = '#{stars}' ORDER BY #{sorting} #{order};")

  @unit = data.values
  erb :child_index
end

def get_unit_info_to_compare(name, db)
  unit_data1 = db.exec("SELECT units.id, name, created_on, stars, type, element, tier, pic1, pic2, pic3, leader, auto, tap, slide, drive, notes FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE name = '#{name}';")

  return nil if unit_data1.ntuples == 0
  unit_data1 = unit_data1.tuple(0)

  unit1 = unit_data1['name']
  date = unit_data1['created_on']
  id = unit_data1['id']

  mainstats1 = {}
  %w(stars type element tier).each do |category|

    mainstats1[category] = unit_data1[category]
  end

  substats1 = {}
  %w(leader auto tap slide drive notes).each do |category|
    substats1[category] = unit_data1[category]
  end

  pics1 = {}
  %w(pic1 pic2 pic3).each do |category|
   pics1[category] = unit_data1[category]
    end
  [unit1, date, id, mainstats1, substats1, pics1]
end

get '/childs/compare/:units' do

  names = params[:units].gsub("'", "''")
  name1, name2 = names.split(",")
  name2 = name1 if name2.nil?
  db = reload_db

  unit1 = get_unit_info_to_compare(name1, db)
  unit2 = get_unit_info_to_compare(name2, db)
  redirect "/search" if [unit1, unit2].any?(&:nil?)
  @unit1, @date1, id, @mainstats1, @substats1, @pics1 = unit1
  @unit2, @date2, id, @mainstats2, @substats2, @pics2 = unit2

  erb :comparison
end

get '/childs/:star_rating/:unit_name' do

  name = params[:unit_name].gsub("'", "''")
  # dd = PG.connect(dbname: 'dcdb')
  db = reload_db

  unit_data = db.exec("SELECT units.id, name, created_on, stars, type, element, tier, pic1, pic2, pic3, leader, auto, tap, slide, drive, notes FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE name = '#{name}';")

  redirect '/' if unit_data.ntuples == 0
  @unit_data = unit_data.tuple(0)

  @unit = @unit_data['name']
  @date = @unit_data['created_on']
  id = @unit_data['id']

  @mainstats = {}
  %w(stars type element tier).each do |category|

    @mainstats[category] = @unit_data[category]
  end

  @substats = {}
  %w(leader auto tap slide drive notes).each do |category|
    @substats[category] = @unit_data[category]
  end

  @pics = {}
  %w(pic1 pic2 pic3).each do |category|
    @pics[category] = @unit_data[category]
  end
  erb :view_unit
end

get '/new_unit' do
  data = reload_db
    one = data.exec("SELECT id, name, created_on FROM units LIMIT 1;").fields
    two = data.exec("SELECT stars, type, element, tier FROM mainstats LIMIT 1;").fields
    three = data.exec("SELECT leader, auto, tap, slide, drive, notes FROM substats LIMIT 1;").fields
  # data = reload_database
  @new_profile = (one + two + three)
  # binding.pry
  @profile_pic_table = data.exec("SELECT pic1, pic2, pic3, pic4 FROM profilepics LIMIT 1;").fields
  erb :new_unit
end

# post requests

post '/new_unit' do
  unit_data = @units

  original_name = params[:original_unit_name]
  name = params[:unit_name].downcase
  unit_id = params['id'].to_i
  data = reload_db
  created_on = params['created_on']

  pname1 = create_file_from_upload(params[:filepic1], params[:pic1], 'public/images')
  pname2 = create_file_from_upload(params[:filepic2], params[:pic2], 'public/images')
  pname3 = create_file_from_upload(params[:filepic3], params[:pic3], 'public/images')
  pname4 = create_file_from_upload(params[:filepic4], params[:pic4], 'public/images')

  check_enabled = (params[:enabled].to_i == 1) ? 't' : 'f'

# this checks if there is a existing unit @ the specific ID
  if data.exec("SELECT * FROM units WHERE id = '#{unit_id}';").first.nil? == true

    if created_on.empty?
      data.exec("INSERT INTO units (name, enabled) VALUES ('#{name}', '#{check_enabled}');")
    else
      data.exec("INSERT INTO units (name, created_on, enabled) VALUES ('#{name}', DEFAULT, '#{check_enabled}');")
    end

    data = reload_db

    current_max_id = data.exec("SELECT id FROM units where name = '#{name}' LIMIT 1;")
    new_id = current_max_id.first['id'].to_i

    if params[:element] == 'grass'
      element = 'earth'
    else
      element = params[:element]
    end
    data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES
    ('#{new_id}', '#{params[:stars]}', '#{params[:type]}', '#{element}', '#{params[:tier]}');")

    data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
    ('#{new_id}', $$#{params[:leader]}$$, $$#{params[:auto]}$$, $$#{params[:tap]}$$, $$#{params[:slide]}$$, $$#{params[:drive]}$$, $$#{params[:notes]}$$);")

    data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES
    ('#{new_id}', '#{pname1}', '#{pname2}', '#{pname3}', '#{pname4}');")
    reload_db

else
# IF there is a unit then it is updated by using the original name and it's ID
    data.exec("UPDATE units SET name = '#{name}', enabled = '#{check_enabled}' WHERE name = '#{original_name}' AND id = '#{unit_id}'")
    reload_db

    if params[:element] == 'grass'
      element = 'grass'
    else
      element = params[:element]
    end
    data.exec("UPDATE mainstats SET stars = '#{params[:stars]}', type = '#{params[:type]}', element = '#{element}', tier = '#{params[:tier]}' WHERE unit_id = #{unit_id}")
    # reload_db

    data.exec("UPDATE substats SET leader = $$#{params[:leader]}$$, auto = $$#{params[:auto]}$$, tap = $$#{params[:tap]}$$, slide = $$#{params[:slide]}$$, drive = $$#{params[:drive]}$$, notes = $$#{params[:notes]}$$ WHERE unit_id = #{unit_id}")

    data.exec("UPDATE profilepics SET pic1 = '#{pname1}', pic2 = '#{pname2}', pic3 = '#{pname3}', pic4 = '#{pname4}' WHERE unit_id = #{unit_id}")
    reload_db
  end

  session[:message] = "New unit called #{name.upcase} has been created."
  redirect "/"
end

###########################
def convert_yml_to_sql
  return
  arr = []
  data = PG.connect(dbname: 'jpdestinydb')  #this is the database it will pour the data into. BE CAREFUL
#
#   load_unit_details.drop(302).first(50).each_with_index do |unit, idx|
#
#     name = unit.first
#     unit = unit.last
#     date = unit['date']
#         #
#         # binding.pry
#   done =  data.exec("SELECT * FROM units WHERE name = $$#{name}$$").ntuples > 0
#   next if done
#
#   # data.exec("UPDATE units SET created_on = $$#{date}$$ where name = $$#{name}$$")
#
#       data.exec("INSERT INTO units (name, created_on, enabled) VALUES ($$#{name}$$, $$#{date}$$, true)")
# data.close
#       data = PG.connect(dbname: 'jpdestinydb')
      # unit_id = data.exec("SELECT id FROM units WHERE name = $$#{name}$$").first['id']
#  puts unit_id
#     if unit['element'] == 'grass'
#       element = 'earth'
#     else
#       element = unit['element']
#     end
#           data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES (#{unit_id.to_i}, '#{unit['stars']}', '#{unit['type']}', '#{element}', '#{unit['tier']}')")
#           data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
#           (#{unit_id.to_i}, $$#{unit['leader']}$$, $$#{unit['auto']}$$, $$#{unit['tap']}$$, $$#{unit['slide']}$$, $$#{unit['drive']}$$, $$#{unit['notes']}$$)")
#     data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES (#{unit_id.to_i}, '#{unit['pic']}', '#{unit['pic2']}', '#{unit['pic3']}', 'emptyunit0.png')")
#
#
#   end

#  SPLITS THE LOAD. Hide the part below, then unhide it and hide top part then refresh the page ELSE connects are too many.

  # load_unit_details.drop(50).each_with_index do |unit, idx|

    x=File.expand_path("data/soul_cards.yml", __dir__)
    y = YAML.load_file(x)
    y.drop(152).first(50).each_with_index do |unit, idx|
    name = unit.first
    pic = unit[1]['pic']
    stars = unit[1]['stars']
    normal = unit[1]['normal'][0].join(' ') # this is array [[1,2,3].[21,12,122]]
    normal2 = unit[1]['normal'][1].join(' ')
    if stars == '5'
      prism = unit[1]['prism'][0].join(' ')  # this is array [[1,2,3].[21,12,122]]
        prism2 = unit[1]['prism'][1].join(' ')
    end
    restriction = unit[1]['passive'][0][1]
    ability = unit[1]['passive'][1][1]
    # date = unit['date']

    data.exec("INSERT INTO soulcards (name, created_on, enabled) VALUES ($$#{name}$$, DEFAULT, true)")

    unit_id = data.exec("SELECT id FROM soulcards WHERE name = $$#{name}$$").first['id']

data.exec("INSERT INTO scstats (sc_id, pic1, stars, normalstat1, normalstat2, prismstat1, prismstat2, ability, restriction) VALUES ($$#{unit_id}$$, $$#{pic}$$, $$#{stars}$$, $$#{normal}$$, $$#{normal2}$$, $$#{prism}$$, $$#{prism2}$$, $$#{ability}$$, $$#{restriction}$$);")
    end


      data.close
end

get '/update' do
  convert_yml_to_sql
  puts 'UPDATED'
end
