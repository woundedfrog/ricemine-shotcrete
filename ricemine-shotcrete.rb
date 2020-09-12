require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'tilt/erubis'
require 'redcarpet'
require 'yaml'
require 'fileutils'
require 'bcrypt'
require 'sysrandom/securerandom'
require 'pry'
require 'zip' # allows for zipping files
require 'pg'
require 'uri'
require 'net/http'
require 'benchmark'

require_relative 'formatnamelist'

include FormatNameList

configure do
  set :erb, escape_html: true
  enable :sessions
  set :sessions, :expire_after => 1840
  set :session_secret, SecureRandom.hex(64)

end

def require_user_signin
  return unless user_signed_in? == false

  session[:message] = 'You don\'t have access to that.'
  add_to_history("Sign-in needed -- Status #{status}.")
  redirect '/'
end

def user_signed_in?
  session.key?(:username)
end

def valid_credentials?(username, password)
  credentials = load_user_credentials

  if credentials.key?(username)
    bcrypt_password = BCrypt::Password.new(credentials[username])
    bcrypt_password == password
  else
    false
  end
end

def load_user_credentials
  credentials_path = File.expand_path('users.yml', __dir__)
  YAML.load_file(credentials_path)
end

def disconnect
puts "connection closed by my ruby methods"
  @data.close
end

def reload_db
  puts "connection opened by my r-methods"
  @data = if ENV['RACK_ENV'] == 'production'
    puts "loaded production!"
    PG.connect('postgresql://doadmin:o4ml2eimtdkun4ij@destiny-gl-jp-do-user-6740787-0.db.ondigitalocean.com:25061/coolpool?sslmode=require')
  else
    puts "loaded development!"
    PG.connect(dbname: "jpdestinylocal")
  end
end

helpers do
  def get_img_link(name, list = false)
    # this gets the full-size image for a link and send placeholder if not found.
    # ../../../images/full_size/full<%= @name.gsub(/\s+/, "")
    name = 'full' + name.gsub(/\s+/, "")

    # path = "https://res.cloudinary.com/mnyiaa/image/upload/riceminejp/full/#{name}.png"
    # if File.exist?(path)
    if list
      # if res.code != '404'
        return "https://res.cloudinary.com/mnyiaa/image/upload/c_scale,h_140,q_60:444/riceminejp/full/#{name}.png"
      # else
      #   return "https://res.cloudinary.com/mnyiaa/image/upload/c_scale,h_140,q_60:444/riceminejp/full/fullmissingpic.png"
      # end
    else
      res = Net::HTTP.get_response(URI("https://res.cloudinary.com/mnyiaa/image/upload/riceminejp/full/#{name}.png"))

      if res.code != '404'
        return "https://res.cloudinary.com/mnyiaa/image/upload/c_scale,h_540,q_100:444/riceminejp/full/#{name}.png"
      else
        return "https://res.cloudinary.com/mnyiaa/image/upload/c_scale,h_540,q_100:444/riceminejp/full/fullmissingpic.png"
      end
    end

  end

  def check_if_any?(idx, tier, units)
    sub_arr = units.map do |arr|
      arr['tiers'].split(" ")[idx]
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
    stat = stat.join(" ")
    stat.split(" ")[part]
  end

  def get_ref_to_info(line)
    return line if !line.include?("$") && !line.include?("#") && !line.include?('^')
    words = line.split(" ")
    data = reload_db
    names = data.exec("SELECT name FROM units;").values.flatten(1)
    sc_names = data.exec("SELECT name FROM soulcards;").values.flatten(1)
    disconnect

    new_words = words.map do |word|
      if word.include?("#")
        get_soulcard_ref(word, sc_names)
      elsif word.include?("$")
        get_unit_ref(word, names)
      elsif word.include?('^')
        get_gif_ref(word)
      else
        word
      end
    end
    new_words.join(" ")
  end

  def replace_text_color(line)
  return line if line.include?("<color") == false
  colors = %w(55ff21 ffffff 00ccff e9d64a e00fff ef4112)
    colors.each do |color|
      if color == 'ffffff'
        line = line.gsub("<color=#{color}>", '<span class=\'buff_icon\' style=\'color: lightblue;\'>')
        line = line.gsub('</color>', '</span>')
      else
        line = line.gsub("<color=#{color}>", "<span class=\'buff_icon\' style=\'color: blue;\'>")
        line = line.gsub('</color>', '</span>')
      end
    end
    line
  end

  def insert_tooltip(line)
  # line
  # line = line.gsub('<color=ffffff>', '<span class=\'buff_icon\' style=\'color: lightblue;\'>')

  line = replace_text_color(line)
  return line
    credentials_path = File.expand_path('data/tooltips.yml', __dir__)
    tooltips_info = YAML.load_file(credentials_path)

    x = line.split(" ").map do |word|
      new_word = word.gsub(/["“”’‘'.,]/, '')
      lookup_word = new_word.downcase
      if word.count("0-9") > 0
        word
      elsif tooltips_info.keys.include?(lookup_word)
        img_word = new_word.include?("!") ? new_word.split("!")[1] : new_word
        hover_word = img_word.gsub(/[-+]/,' ').split(' ').map(&:capitalize).join(' ')

        "<a class='tooltip' style=''>#{hover_word}<span class='tooltiptext'><img src='/images/skills/#{img_word.downcase}.png'></img>#{tooltips_info[lookup_word]}</span></a>"
      else
        word
      end
    end.join(" ")
  end

  def format_buffs(buff)
    return '/images/' + buff.gsub('buff_set', 'img/value.png')
  end
end
#### END OF HELPER METHODS #####

def get_gif_ref(word)
  word = word.gsub(/[\^\:']/,'')
  test_word = word.gsub(/[,.]/, '').downcase
    "<img src='/images/skills/#{test_word}.gif' style='max-width: 30px;'></img>"
end

def get_soulcard_ref(word, sc_names)
  word = word.gsub(/[\#\']/,'').gsub("_", " ")
    test_word = word.gsub(/[,.]/, '').downcase
    if sc_names.include?(test_word.downcase)
      "<a class='linkaddress' href='/soulcards/5/#{test_word}' style='color: #efff02;'>#{word.upcase}</a>"
    end
end

def get_unit_ref(word, names)
  word = word.gsub(/[\$\']/,'').gsub("_", " ")
  test_word = word.gsub(/[,.]/, '').downcase
  if names.map(&:downcase).include?(test_word.downcase)
  p names
    "<a class='linkaddress' href='/childs/5stars/#{test_word}' style='color: #efff00;'>#{word.upcase}</a>"
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

  def fetch_json_data(type)
    case type
    when 'mainjp'
      JSON.parse(File.read('data/CharacterDatabaseJp.json'))
    when 'reflistdb'
      JSON.parse(File.read('data/character_idx_name.json'))
    when 'soulcarddb'
      JSON.parse(File.read('data/soulcardDatabaseJp.json'))
    when 'mainen'
      JSON.parse(File.read('data/CharacterDatabaseEn.json'))
    end
  end

  def backup_tooltips(tooltip)
    date = DateTime.now.strftime("%d-%m-%Y-%Hh%Mm")
    FileUtils.cp('data/tooltips.yml', "data/ymlbackup/" + date +'-tooltips.yml')

    path = File.join('data/', 'tooltips.yml')
    File.open(path, 'wb') { |f| f.write(tooltip) }

  end

  def add_to_history(info, search = false)
  path = if search
            File.expand_path('data/search_log.yml', __dir__)
         else
            File.expand_path('data/history_log.yml', __dir__)
         end
    data = YAML.load_file(path)

      if data.size >= 200
        data.shift(10)
        new_log = Time.now.utc.localtime('+09:00').to_s + " [#{info}]"
      else
        new_log = Time.now.utc.localtime('+09:00').to_s + " [#{info}]"
      end

      data << new_log

      if search
        path = File.join('data/', 'search_log.yml')
        File.open(path, 'wb') { |f| f.write(data) }
      else
        path = File.join('data/', 'history_log.yml')
        File.open(path, 'wb') { |f| f.write(data) }
      end
  end

def format_stat(stat_key, info_val)
  if info_val == 'Supporter'
    info_val = 'buffer'
  elsif info_val == 'Forest'
    info_val = 'forest'
  end
  if stat_key == 'stars'
    "<img class=\'star_rating\' src='https://res.cloudinary.com/mnyiaa/image/upload/v1583812290/riceminejp/stats/star#{info_val}.png' alt='#{info_val}'stars/>"
  elsif %w[tank attacker buffer healer debuffer water fire forest light dark].include?(info_val.downcase)
    "<img class=\'element-type-pic\' src='https://res.cloudinary.com/mnyiaa/image/upload/v1583812290/riceminejp/stats/#{info_val}.png' alt='#{info_val}'/>"
  else
    info_val
  end
end

def upcase_name(name)
  return name.capitalize if !name.include?(" ")
  name.split(' ').map(&:capitalize).join(' ')
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

def filter_and_sort(found_data, data)
  data.values.each do |dd|
    if found_data.include?(dd)
      next
    else
      found_data << dd
    end
  end
  return found_data
end

def ana(data) #this is to test query performance
  puts "LOADED ANALYZING DATA"
  data.each do |query_line|
    p query_line
  end
end

# finding data to the untis.
def get_buff_icon_path(info)
  buffs = []
  info.each do |k,v|
    buffs << v['icon']
  end
  buffs
end

def sort_assign_data(data_dump, reference_list, name, usage, ignited = false)

  char_hash = {}
  mainstats = {}
  substats = {}
  buffs = {}
  pics = {}
  character = data_dump

  #this x call writes data like tiers and such if unit already exists Can delete when files are uptodatess
  # binding.pry
  # quick_ref_list_build_from_yaml_and_other_files(character, name)
  # return
  #end
  if usage == 'search'
    char_hash['char_code'] = (character['skins'].keys[0][0..4] + '01')
    char_hash['char_idx'] = character['idx']
    char_hash['en_name'] = name
    char_hash['role'] = character['role']
    char_hash['attribute'] = character['attribute']
    char_hash
  elsif usage == 'profile'
    skills = if ignited && !character['skills_ignited'].empty?
        character['skills_ignited']
      else
        character['skills']
      end
     code = character['skins'].keys[0].include?("m") ? character['skins'].keys[0] :(character['skins'].keys[0][0..4] + '02')
    char_hash['char_code'] = code
    char_hash['char_idx'] = character['idx']
    char_hash['char_kr_name'] = character['name']
    char_hash['char_jp_name'] = character['skins'].values[0]
    char_hash['char_jp_skin'] = character['skins'].values[0] # wasted
    char_hash['char_jp_skin_name'] = character['skins'].values[0] # wasted
    mainstats['stars'] = character['grade']
    mainstats['role'] = character['role']
    mainstats['attribute'] = character['attribute']
    mainstats['tier'] = reference_list['tiers']
    substats['auto'] = skills['default']['text']
    substats['tap'] = skills['normal']['text']
    substats['slide'] = skills['slide']['text']
    substats['drive'] = skills['drive']['text']
    substats['leader'] = skills['leader']['text']
    substats['notes'] = reference_list['notes']
    substats['date'] = reference_list['date']
    buffs['tap_buffs_path'] = get_buff_icon_path(skills['normal']['buffs'])
    buffs['slide_buffs_path'] = get_buff_icon_path(skills['slide']['buffs'])
    buffs['drive_buffs_path'] = get_buff_icon_path(skills['drive']['buffs'])
    buffs['leader_buffs_path'] = get_buff_icon_path(skills['leader']['buffs'])
    pics['pics'] = character['skins'].keys[0]
    pics['pics2'] = character['skins'].keys[1]
    pics['pics3'] = character['skins'].keys[2]
    pics['pics3'] = character['skins'].keys[3]
    [char_hash, mainstats, substats, buffs, pics, character['skills_ignited'].empty?]
  else
    code = character['skins'].keys[0].include?("m") ? character['skins'].keys[0] :(character['skins'].keys[0][0..4] + '02')
    char_hash['char_code'] = code
    char_hash['char_idx'] = character['idx']
    char_hash['en_name'] = name
    char_hash['kr_name'] = character['name']
    char_hash['jp_name'] = character['skins'].values[0]
    char_hash['role'] = character['role']
    char_hash['attribute'] = character['attribute']
    char_hash['pics'] = code
    char_hash['stars'] = character['grade']
    char_hash['date'] = reference_list['date']
    char_hash['tiers'] = reference_list['tiers']
    [char_hash]
  end
end

def check_and_get_if_profile_exist(query, reference_list)
  ref = ''
  query = query.downcase.gsub(" ", "")
  reference_list.each do |k,_|
    if (k['en_name'].downcase.gsub(" ", "") == query ||
        k['kr_name'].downcase.gsub(" ", "") == query ||
        k['jp_name'].downcase.gsub(" ", "") == query)
      ref = k
    end
  end
  ref
end

def generate_json_skills(name, code, ignited = false)
  data_dump = fetch_json_data('mainjp')
  reference_list = fetch_json_data('reflistdb')
  name = name.downcase
  reference_data = check_and_get_if_profile_exist(name, reference_list)
  char_idx_num = reference_data['idx']

#  # ENABLE this if you want to add new units to the ref list, via name and code
  # if char_idx_num.nil?
  #   added_name = add_names_json_ref_list(name, code)  # used when creating new entries if none exist
  #   char_idx_num = check_and_get_if_profile_exist(name, reference_list)
  #   p "this added code: #{char_idx_num} name: #{name} to the list"
  # end

  data_dump_idx = data_dump.find_index {|k,_| (k['skins'].keys[0][0..4] + '01') == code || k['idx'] == char_idx_num }

   ## failsafe default unit to load if missing.

  # data_dump_idx, char_idx_num = [0,'10100002'] if char_idx_num.nil? && data_dump_idx.nil?
  # retirect "/" if char_idx_num.nil?
  redirect '/' if data_dump_idx.nil? && char_idx_num.nil?
  sort_assign_data(data_dump[data_dump_idx], reference_data, name, 'profile', ignited)
end

#### routes ####
not_found do
  redirect '/'
end

error 400..510 do
  session[:message] = 'Sorry something bad happened!'
  add_to_history(session[:message] + "--- Error: #{status}")
  redirect '/'
end

get '/users/signin' do
  erb :signin
end

get '/' do
    main_db_dump = fetch_json_data('mainjp')
    name_ref_list = fetch_json_data('reflistdb')
    sc_ref_list = fetch_json_data('soulcarddb')
    recent_units = name_ref_list.sort_by {|k| [k['date'],k['en_name']]}[-5..-1]
    recent_sc = sc_ref_list.sort_by {|k| [k['date'],k['en_name']]}[-5..-1]

    selected_info = []
    recent_units.each do |unit|
    idx_num = unit['idx']
      data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
      selected_info << sort_assign_data(main_db_dump[data_dump_idx], unit, unit['en_name'], false) # false to say it isn't for profile
    end

  @unit = selected_info.flatten

  @soulcards = recent_sc
  # disconnect
  erb :home
end

get '/log/:type' do
  type = params[:type]
  redirect '/' if (type != 'search' && type != 'history')

  path = File.expand_path("data/#{type}_log.yml", __dir__)
  @history = YAML.load_file(path)

  # path = File.expand_path('data/basics.md', __dir__)
  # @markdown = load_file_content(path)
  erb :history
end

get '/search-results/' do
  redirect '/' if params[:search2].nil? || params[:search2].empty?
  words = params[:search2].downcase
  # keys = words.split(" ").prepend(words)
  #
  # keys = [words, words.gsub('-',' '), words.gsub(' ','-')]
  # hidden = keys.include?(":s")

  main_db_dump = fetch_json_data('mainjp')
  name_ref_list = fetch_json_data('reflistdb')
  selected_info = search_data_for_keywords(main_db_dump, name_ref_list, words)
  found_by_name = []
  found_by_stats = []

  selected_info[0].each do |unit|
    next if unit.nil?
    idx_num = unit['idx']
    data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
    found_by_name << sort_assign_data(main_db_dump[data_dump_idx], nil, unit['en_name'], 'search') # false to say it isn't for profile
  end

  selected_info[1].each do |unit|
    next if unit.nil?
    idx_num = unit['idx']
    data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
    found_by_stats << sort_assign_data(main_db_dump[data_dump_idx], nil, unit['en_name'], 'search') # false to say it isn't for profile
  end

    @unit = found_by_name.flatten
    @unit2 = found_by_stats.flatten
  erb :search_results
end

get '/tiers/:stars' do
  stars = params[:stars]
  redirect "/" if !['3','4','5'].include?(stars)
  # db = reload_db
  # # binding.pry
  # unit_data = db.exec("SELECT units.id, name, type, element, stars, pic1, tier FROM units
  # RIGHT OUTER JOIN mainstats on unit_id = units.id
  # RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id where stars = '#{stars}' ORDER BY name ASC;")
  #
  @tiers = %w(10 9 8 7 6 5 4 3 2 1 0)
  @sorted_by = %w(PVE PVP RAID WORLDBOSS)
  # @unit = unit_data.values
  # disconnect

  order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
  stars = params[:stars]
  sorting = params[:sorting]

  selected_info = case stars
                  when '3'
                    sort_grab_by_stars('3')
                  when '4'
                    sort_grab_by_stars('4')
                  when '5'
                    sort_grab_by_stars('5')
                  end


  @unit = selected_info

  erb :child_tiers
end

get '/soulcards' do
  redirect '/soulcards/5'
end

get '/soulcards/:stars/:name' do
    name = params[:name].gsub("'", "\'")

  @soulcard = sc_data_from_yml(name)
  erb :view_sc
end

get '/soulcards/:stars' do
  stars = params[:stars]
  redirect "/soulcards/5" if !['3','4','5'].include?(stars)

  sc_ref_list = JSON.parse(File.read('data/soulcardDatabaseJp.json'))

  sc_ref_list = sc_ref_list.select {|k| k['grade'] == stars.to_i}
  recent_sc = sc_ref_list.sort_by {|k| [k['date'],k['en_name']]}.reverse

  @soulcards = recent_sc
  erb :soulcard_index
end

get '/sort/:stars/:sorting' do
  order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
  stars = params[:stars]
  sorting = params[:sorting]

  selected_info = case stars
                  when '3'
                    sort_grab_by_stars('3')
                  when '4'
                    sort_grab_by_stars('4')
                  when '5'
                    sort_grab_by_stars('5')
                  end

  @sorted_by = if sorting == 'element'
                  ['water', 'fire', 'forest', 'light', 'dark']
                elsif sorting == 'type'
                  ['attacker', 'healer', 'debuffer', 'buffer', 'tank']
                elsif sorting == 'date'
                  x = []
                  selected_info.flatten.each do |k|
                    x << k['date']
                  end
                  x.uniq.sort.reverse
                end

  @unit = selected_info
  erb :child_index
end

get '/childs/:star_rating/:unit_name' do
  u_name, u_code = params[:unit_name].split(',')

  # iterates through reference lists and saves all tier and notes data to it.
  # yamlf = File.expand_path('data/unit_details.yml', __dir__)
  # yaml_data = YAML.load_file(yamlf)
  # yaml_data.keys.each do |name|
  #   p name
  #
  #   generate_json_skills(name, u_code)
  # end
  @generated_info = generate_json_skills(u_name, u_code)

  name = u_name.gsub("'", "\'")

  @unit = name

  @char_info, @mainstats, @substats, @buffs, @pics, @ignited  = @generated_info

  erb :view_unit_normal
end

get '/childs/:star_rating/ignited/:unit_name' do
  u_name, u_code = params[:unit_name].split(',')

  # iterates through reference lists and saves all tier and notes data to it.
  # yamlf = File.expand_path('data/unit_details.yml', __dir__)
  # yaml_data = YAML.load_file(yamlf)
  # yaml_data.keys.each do |name|
  #   p name
  #
  #   generate_json_skills(name, u_code)
  # end
  @generated_info = generate_json_skills(u_name, u_code, true)

  name = u_name.gsub("'", "\'")

  @unit = name

  @char_info, @mainstats, @substats, @buffs, @pics  = @generated_info

  erb :view_unit_ignited
end

get '/new/unit_new' do
  require_user_signin

  one = %w(idx code en_name jp_name kr_name tiers notes date)

  @new_profile = (one)

  @profile_pic_table = %w(image1 image2 image3)

    main_db_dump = fetch_json_data('mainjp')
    name_ref_list = fetch_json_data('reflistdb')

  erb :new_unit
end


get '/new/equips/new_sc' do
  # require_user_signin
  @new_profile = %w(idx dbcode grade code jp_name kr_name normalstat1 normalstat2 prismstat1 prismstat2 restriction ability notes date)
  @profile_pic_table = ['pic']
  @max_idx = fetch_json_data('soulcarddb').map {|k| k['dbcode']}.max + 1

  erb :new_sc
end

get '/edit_unit/:unit_name' do
  require_user_signin
  name = params[:unit_name].downcase
  main_db_dump = fetch_json_data('mainjp')
  name_ref_list = fetch_json_data('reflistdb')
  ref_profile = check_and_get_if_profile_exist(name, name_ref_list)
  redirect '/' if ref_profile.empty?

  index = main_db_dump.find_index {|k,_| k['idx'] == ref_profile['idx'] }

  data = main_db_dump[index]
  @new_profile = ref_profile

  @profile_pic_table = {'image1' => ref_profile['image1'], 'image2' => ref_profile['image2'], 'image3' => ref_profile['image3']}
  path = File.expand_path('data/tooltips.yml', __dir__)
  @tooltip_dump = YAML.dump(YAML.load_file(path))

  erb :edit_unit
end

get '/edit_sc/:sc_name' do
  require_user_signin

    name = params[:sc_name].gsub("'", "''").downcase
  data = reload_db

  if (data.exec("SELECT id FROM units WHERE name = '#{name}';").ntuples == 0 && data.exec("SELECT id FROM soulcards WHERE name = '#{name}';").ntuples == 0)
    session[:status] = 442
    session[:message] = "That profile doesn't exist!"
    add_to_history("That profile doesn't exist! '#{name}' does not exist.")
    redirect '/'
  end
  one = data.exec("SELECT soulcards.id, name, created_on, stars, normalstat1, normalstat2, prismstat1, prismstat2, restriction, ability, notes
                   FROM soulcards
                   RIGHT JOIN scstats on scstats.sc_id = soulcards.id
                   WHERE name = '#{name}';").tuple(0)
  # data = reload_database
  @new_profile = one
  # binding.pry
  @profile_pic_table = data.exec("SELECT pic1 FROM scstats WHERE sc_id = (SELECT id FROM soulcards WHERE name = '#{name}') LIMIT 1;").tuple(0)

  disconnect
  erb :edit_sc
end

get '/unit_edit_list' do


  @unit = sort_grab_by_stars('all').flatten

  erb :unit_edit_list
end

get '/sc_edit_list' do
  redirect '/'
  db = reload_db

  sc_data = db.exec("SELECT name, pic1, stars, enabled
    FROM (SELECT * FROM soulcards) as soulcards
    RIGHT OUTER JOIN scstats on scstats.sc_id = soulcards.id
    ORDER BY created_on DESC, name ASC;")

    disconnect
  @soulcards = sc_data.values
  erb :sc_edit_list
end

get '/unit_details_get' do
  data = reload_db
  @unit_details = data.exec("SELECT name FROM units;")
  @sc_details = data.exec("SELECT name FROM soulcards;")
  disconnect
  erb :show_unit_details
end

get '/files/:type' do
  require_user_signin
  type = params[:type]
    redirect '/' if !['sc','unit','units','full','soulcard','soulcards'].include?(type)
  pic = if type == 'full'
      'pic2'
  elsif type == 'unit'
      'pic1'
  end

  data = reload_db
  if ['unit', 'units', 'full'].include?(type)
    @units = data.exec("SELECT units.id, name, created_on, #{pic} FROM units
    RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
    RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
    WHERE mainstats.stars = '5' OR mainstats.stars = '4';")
    @soulcards = []
  else
    @soulcards = data.exec("SELECT soulcards.id, name, created_on, pic1 FROM soulcards
    RIGHT OUTER JOIN scstats ON scstats.sc_id = soulcards.id;")
      @units =[]
  end
  disconnect
  erb :file_list
end

get '/:type/:name' do  #remove a unit/soulcard
  require_user_signin

  type = params[:type]
  name = params[:name]
  data = reload_db

  if (data.exec("SELECT id FROM units WHERE name = '#{name}';").ntuples == 0 && data.exec("SELECT id FROM soulcards WHERE name = '#{name}';").ntuples == 0)
    session[:status] = 442
    session[:message] = "That profile doesn't exist!"
    add_to_history("That profile doesn't exist! Attemped to #{type.upcase} '#{name.upcase}'.")
    redirect '/'
  end
    if type == 'unit_remove'
      id = data.exec("SELECT id FROM units where name = '#{name}';").tuple(0)['id']
      data.exec("DELETE FROM profilepics WHERE unit_id = '#{id}';")
      data.exec("DELETE FROM substats WHERE unit_id = '#{id}';")
      data.exec("DELETE FROM mainstats WHERE unit_id = '#{id}';")
      data.exec("DELETE FROM units WHERE id = '#{id}';")
    elsif (type == 'sc_remove')
      id = data.exec("SELECT id FROM soulcards where name = '#{name}';").tuple(0)['id']
      data.exec("DELETE FROM scstats WHERE sc_id = '#{id}';")
      data.exec("DELETE FROM soulcards WHERE id = '#{id}';")
    end

  disconnect
  redirect '/'
end

get '/upload_file' do

  erb :upload
end

# post requests
post '/signin' do
  username = params[:username]
  password = params[:password]

  if valid_credentials?(username, password)
    session[:username] = username
    session[:message] = 'Welcome!'
    redirect '/'
  else
    session[:message] = 'Invalid credentials!'
    status 422
    erb :signin
  end
end

post '/logout' do
 session.clear
 redirect '/'
end

post '/new_unit' do
  require_user_signin

  name_ref_list = fetch_json_data('reflistdb')

  original_name = !params[:current_unit_name].nil? ? params[:current_unit_name].gsub("'", "''").downcase : ''
  updated_unit_name = params['en_name'].empty? ? original_name : params['en_name']
  idx_of_arr_data = name_ref_list.find_index {|k,_| k['idx'] == params['idx'] }
  updated_unit = {}

  new_time = Time.now.utc.localtime('+09:00')
  params['date'] = [new_time.year, new_time.month, new_time.day].join('-') if params['date'].empty?

   params.each do |k, v|
     next if %w(current_unit_name edited enabled tooltip skill_dump).include?(k)
    if k == 'en_name' && v.empty?
      updated_unit[k] = original_name
    else
      updated_unit[k] = v
    end
   end

   sort_order = [:idx, :code, :en_name, :jp_name, :kr_name, :image1, :image2, :image3, :tiers, :notes, :date]
   updated_unit = updated_unit.sort_by { |k, _| sort_order.index(k.to_sym) }.to_h

   if idx_of_arr_data.nil?
     name_ref_list << updated_unit
   else
     name_ref_list[idx_of_arr_data] = updated_unit
   end

  session[:message] = "New unit called #{updated_unit_name.upcase} has been created."
  add_to_history("New unit called #{updated_unit_name.upcase} has been created.")
  puts "-- Updated Unit '#{updated_unit_name}' Profile! --"

  File.open('data/character_idx_name.json', 'w') { |file| file.write(name_ref_list.to_json) }

  redirect "/"
end

post '/new_sc' do
  require_user_signin

  original_name = if !params[:current_sc_name].nil?
    params[:current_sc_name].gsub("'", "\'").downcase
  else
    ''
  end
  sc_ref_list = fetch_json_data('soulcarddb')
  card_data = YAML.load_file(File.expand_path('data/soul_cards.yml', __dir__))

  name = params[:sc_name].gsub("'", "\'").downcase
  sc_id = params['dbcode'].to_i

  created_on = params['date']
  image = params[:pic].gsub(/[\s\'_]/, "")
  check_enabled = (params[:enabled].to_i == 1) ? 't' : 'f'
  new_time = Time.now.utc.localtime('+09:00')
  created_on = [new_time.year, new_time.month, new_time.day].join('-') if created_on.empty?
  card_data
  new = {}

  new['pic'] = image
  new['enabled'] =  true
  new['stars'] =  params[:grade].to_s
  new['normal'] = [format_new_sc_stats(params[:normalstat1]), format_new_sc_stats(params[:normalstat2])]
  if !params[:prismstat1].nil?
    new['prism'] = [format_new_sc_stats(params[:prismstat1]), format_new_sc_stats(params[:prismstat2])]
  end
  restrict = 'restriction ' + params[:restriction]
  ability = 'ability ' + params[:ability]
  passive = [restrict, ability].flatten.join(" ")
  new['passive'] = format_new_sc_stats(passive, true)
  new['index'] = params[:dbcode]

binding.pry
  if card_data[name] && card_data[name]['index'].to_i != params['idx'].to_i
    name = name + '2'
    card_data[name] = new
  else
    card_data[name] = new
  end

  File.write('data/soul_cards.yml', YAML.dump(card_data))

  dmp = {
    "idx"=> params['idx'],
    "dbcode"=>params['dbcode'],
    "grade"=>params['grade'].to_i,
    "code"=>params['code'],
    "en_name"=>name,
    "jp_name"=>params['jp_name'],
    "kr_name"=>params['kr_name'],
    "image1"=>image,
    "notes"=>params['notes'],
    "date"=>created_on
  }
  sc_ref_list << dmp
  File.open('data/soulcardDatabaseJp.json', 'w') { |file| file.write(sc_ref_list.to_json) }

  session[:message] = "New soulcard called #{name.upcase} has been created."
  add_to_history("New soulcard called #{name.upcase} has been created.")
  puts "-- Updated Unit Profile! --"
  redirect "/"
end

post '/uploadlocal' do
  require_user_signin
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    session[:message] = 'No file selected'
    redirect '/upload'
  end

  directory =
    if ['history_log.yml', 'search_log.yml'].include?(name)
      'data/'
    elsif name == 'soul_cards.yml'
      'data/sc/'
    elsif name.include?('.css')
      'public/stylesheets/'
    elsif name.include?('.png')
      'public/images/skills'
    else
      session[:message] = 'Not a valid file-type'
      redirect '/upload'
    end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  session[:message] = 'file uploaded!'
  add_to_history("File uploaded: #{name}")

  erb :upload
end





#### UPDATE methods to udpate db from yml files.

def update_method_looper
  counter = 0
  loop do
    convert_yml_to_sql(counter)
   # sc_yml_to_sql(counter)
   puts sleep 2
   break if counter >= 350

   counter += 50
   puts counter
  end
end

def update_db(data, unit, name)
  # binding.pry
  id = data.exec("SELECT id FROM units WHERE name = $$#{name}$$").first['id']
  data.exec("UPDATE mainstats
    SET tier = $$#{unit['tier']}$$
    WHERE unit_id = #{id.to_i};")

    data.exec("UPDATE substats
      SET leader = $$#{unit['leader']}$$,
          auto = $$#{unit['auto']}$$,
          tap = $$#{unit['tap']}$$,
          slide = $$#{unit['slide']}$$,
          drive = $$#{unit['drive']}$$,
          notes = $$#{unit['notes']}$$
      WHERE unit_id = #{id.to_i};")

      data.exec("UPDATE profilepics
        SET pic1 = $$#{unit['pic']}$$,
            pic2 = $$#{unit['pic2']}$$,
            pic3 = $$#{unit['pic3']}$$,
            pic4 = $$#{unit['pic4']}$$
        WHERE unit_id = #{id.to_i}")
        puts "updated with new data. Unit: #{name}"
end

def sc_yml_to_sql(drop_counter)
  arr = []
  data = PG.connect('postgresql://doadmin:o4ml2eimtdkun4ij@destiny-gl-jp-do-user-6740787-0.db.ondigitalocean.com:25061/coolpool?sslmode=require')
   #PG.connect(dbname: 'jpdestinylocal')


  x=File.expand_path("data/soul_cards.yml", __dir__)
  y = YAML.load_file(x)
  y.drop(drop_counter).first(50).each_with_index do |unit, idx|
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
  notes = unit[1]['notes']
  # date = unit['date']

    done =  data.exec("SELECT * FROM soulcards WHERE name = $$#{name}$$").ntuples > 0
    # binding.pry
        if done

          next
        end
  data.exec("INSERT INTO soulcards (name, created_on, enabled) VALUES ($$#{name}$$, DEFAULT, true)")

  unit_id = data.exec("SELECT id FROM soulcards WHERE name = $$#{name}$$").first['id']

data.exec("INSERT INTO scstats (sc_id, pic1, stars, normalstat1, normalstat2, prismstat1, prismstat2, ability, restriction, notes) VALUES ($$#{unit_id}$$, $$#{pic}$$, $$#{stars}$$, $$#{normal}$$, $$#{normal2}$$, $$#{prism}$$, $$#{prism2}$$, $$#{ability}$$, $$#{restriction}$$, $$#{notes}$$);")
  end

  data.close
 puts "updated the sc stuff"
end

###########################
def convert_yml_to_sql(drop_counter)
  # return
  arr = []
  data = PG.connect('postgresql://doadmin:o4ml2eimtdkun4ij@destiny-gl-jp-do-user-6740787-0.db.ondigitalocean.com:25061/coolpool?sslmode=require')
   #PG.connect(dbname: 'jpdestinylocal')  #this is the database it will pour the data into. BE CAREFUL
#
  load_unit_details.drop(drop_counter).first(50).each_with_index do |unitpro, idx|

    name = unitpro.first
    unit = unitpro.last
    date = unit['date']
        #
        # binding.pry
  done =  data.exec("SELECT * FROM units WHERE name = $$#{name}$$").ntuples > 0
  # binding.pry


      if done
        update_db(data, unit, name)
        next
      else
#
    # data.exec("UPDATE units SET created_on = $$#{date}$$ where name = $$#{name}$$")

        data.exec("INSERT INTO units (name, created_on, enabled) VALUES ($$#{name}$$, $$#{date}$$, true);")
        data.close
        data = PG.connect(dbname: 'jpdestinylocal')
        unit_id = data.exec("SELECT id FROM units WHERE name = $$#{name}$$;").first['id']
        # binding.pry
        puts unit_id
        if unit['element'] == 'grass'
          element = 'earth'
        else
          element = unit['element']
        end
            data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES (#{unit_id.to_i}, '#{unit['stars']}', '#{unit['type']}', '#{element}', '#{unit['tier']}')")
            data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
            (#{unit_id.to_i}, $$#{unit['leader']}$$, $$#{unit['auto']}$$, $$#{unit['tap']}$$, $$#{unit['slide']}$$, $$#{unit['drive']}$$, $$#{unit['notes']}$$)")
      data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES (#{unit_id.to_i}, '#{unit['pic']}', '#{unit['pic2']}', '#{unit['pic3']}', 'emptyunit0.png')")

      puts "Inserted new data into units!"

    end
  end

#  SPLITS THE LOAD. Hide the part below, then unhide it and hide top part then refresh the page ELSE connects are too many.


  # sc_yml_to_sql(data, drop)
data.close
  # disconnect
end

get '/update' do
  redirect '/'
#  return
  update_method_looper
  puts 'UPDATED'
end
