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
  @data = PG.connect(dbname: "jpdestinydb")
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
    "<img class=\'element-type-pic\' src='/images/stats/#{info_val}.png'/>"
  elsif %w[tank attacker buffer healer debuffer].include?(info_val)
    "<img class=\'element-type-pic\' src='/images/stats/#{info_val}.png'/>"
  elsif stat_key == 'stars'
    "<img class=\'star_rating\' src='/images/stats/star#{info_val}.png'/>"
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

  sc_data = db.exec("SELECT name, pic1 FROM soulcards RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id;")
# binding.pry
  @unit = unit_data.values
  @soulcards = sc_data.values
  erb :home
end

get '/tiers/:stars' do
  # @unit = load_unit_details
  stars = params[:stars]
  redirect "/" if !['3','4','5'].include?(stars)
  db = reload_db
  # binding.pry
  unit_data = db.exec("SELECT units.id, name, type, element, stars, pic1 FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id where stars = '#{stars}' ORDER BY name ASC;")

  @unit = unit_data.values
  erb :child_index
end

get '/soulcards' do
  db = reload_db
  sc_data = db.exec("SELECT name, pic1 FROM soulcards RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id;")

  # x=File.expand_path("data/soul_cards.yml", __dir__)
  # y = YAML.load_file(x)
  @soulcards = sc_data.values
  erb :soulcard_index
end

get '/soulcards/:name' do
    db = reload_db
  sc_data = db.exec("SELECT name, pic1, stars, normalstat1, normalstat2, prismstat1, prismstat2, restriction, ability FROM soulcards
    RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
    WHERE name = '#{params[:name]}';")
  @soulcard = sc_data.values
  erb :view_sc
end

get '/sort/:stars/:sorting' do
  order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
  stars = params[:stars]
  sorting = params[:sorting]
db = reload_db
  data = db.exec("SELECT units.id, name, type, element, stars, pic1, created_on AS date FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id where stars = '#{stars}' ORDER BY #{sorting} #{order};")

  @unit = data.values
  erb :child_index
end

get '/childs/:star_rating/:unit_name' do
  name = params[:unit_name]
  # dd = PG.connect(dbname: 'dcdb')
  db = reload_db

  unit_data = db.exec("SELECT units.id, name, stars, type, element, tier, pic1, pic2, pic3, leader, auto, tap, slide, drive, notes FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE name = '#{name}';")

  redirect '/' if unit_data.ntuples == 0
  @unit_data = unit_data.tuple(0)

  @unit = @unit_data['name']

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

def convert_yml_to_sql
  # return
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
