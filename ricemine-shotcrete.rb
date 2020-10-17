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

REGION = "JAPAN"

configure do
  set :erb, escape_html: true
  enable :sessions
  set :sessions, :expire_after => 1840
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

end

def require_user_signin
  return unless user_signed_in? == false

  puts  "#{request.ip}: origin: #{uri}"
  session[:message] = 'You don\'t have access to that.'

  add_to_history("Sign-in attemp -- Status #{status}. (IP: #{request.ip}: Origin: '#{uri}')", true)
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

helpers do

  def get_image_link(image_n)
    path = image_n

    if REGION == 'JAPAN'
      if !path.include?("/jp/")
        path = path.gsub('/images/sc/', '/images/sc/jp/')
      end
      path = path.gsub(/[^\/^a-z^0-9\.]/i, '')
    elsif REGION == 'GLOBAL'
      if !path.include?("/gl/")
        path = path.gsub('/images/sc/', '/images/sc/gl/')
      end
      path = path.gsub(/[^\/^a-z^0-9\.]/i, '')
    else
      image_n
    end

  end

  def get_img_link(name, list = false)
    # this gets the full-size image for a link and send placeholder if not found.
    # ../../../images/full_size/full<%= @name.gsub(/\s+/, "")

    # name = name.split(" ")[-2..-1].join(" ")
    name = name.downcase.gsub(/[^a-z]/i, '')
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
    # return line
    return line if !line.include?("$") && !line.include?("#") && !line.include?('^')
    words = line.split(" ")
    data = []#reload_db
    names = fetch_json_data('reflistdb').map{ |l| l['en_name'] }

    sc_names = []#data.exec("SELECT name FROM soulcards;").values.flatten(1)

    new_words = words.map do |word|
      if word.include?("#")
        get_soulcard_ref(word, sc_names)
      elsif word.include?("$")
        x = get_unit_ref(word, names)
        x.nil? ? word : x
      elsif word.include?('^')
        get_gif_ref(word)
      else
        word
      end
    end
    new_words.join(" ")
  end

  def fix_skill_description_issue(line, skill_details = nil)
    # This replaced incorrect skills data if needed. like colors if missing or wrong wording
    fix = ''
    if REGION == 'JAPAN'
      fix = [["Chance for <color=ffffff>Vampirism", "of damage dealt as <color=ffffff>Vampirism"],
         ["Chance for <color=ffffff>Hp Absorb", "of damage dealt used as<color=ffffff>Hp Absorb"],
         ["Chance for <color=ffffff>Revenge", "of damaged received is returned to enemy in <color=ffffff>Revenge"],
         ["Chance for <color=ffffff>Reflect</color>",
          "of damaged received is used as <color=ffffff>Reflect</color> damaged and applied"],
         ["Chance for <color=ffffff>Lifelink</color>",
          "of damaged received is converted to healing through <color=ffffff>Lifelink</color> applied"],
         ["Chance for <color=ffffff>Blind</color>", "decreased Accuracy to target through <color=ffffff>Blind</color> debuff"],
         ["Chance for <color=ffffff>Protection Buff Off</color>",
          "Chance to remove enemy protection buffs (regen,lifesteal, healing) through <color=ffffff>Protection Buff Off</color> applied"],
         ["Chance for <color=ffffff>Awakening</color>", "Chance to apply <color=ffffff>Awakening</color>"]].to_h
    else
      fix = [['Vampirism for', '<color=ffffff>Vampirism</color> for']].to_h
    end

    if REGION == 'JAPAN'
      fix.each do |key, val|
        if line.include?(key)
          p 'fixed skill line'
          line = line.gsub(key, val)
        end
      end
    else
      # this adds a color effect to GLOBAL skills if there aren't any.
      skill_details.each do |key, val|
        val.each do |k,v|
          skill_n = k
          description = v

          if line.include?(skill_n)
              line = line.gsub(" #{skill_n} ", " <color=ffffff>#{skill_n}</color> ")
          end
        end
      end
    end

    line
  end

  def replace_text_color(line)
    return line if line.include?("<color") == false
    colors = %w(55ff21 ffffff 00ccff e9d64a e00fff ef4112)
    # line = fix_skill_description_issue(line)
    colors.each do |color|
      if color == 'ffffff'
        line = line.gsub("<color=#{color}>", '<span class=\'buff_icon_name\'>')
        line = line.gsub('</color>', '</span>')
      else
        line = line.gsub("<color=#{color}>", "<span class=\'buff_icon_name\'>")
        line = line.gsub('</color>', '</span>')
      end
    end
    line
  end

  def add_skill_description(line, skill_details, skill_type)
    regex = /(?<=\>)(.*?)(?=\<)/
    skill_n = line[regex, 1]
    skill_type += "_skill_detail"
    return line if skill_n.nil?
    skill_details[skill_type].uniq.each do |info|
      [info].to_h.each do |name, txt|
        next if ['Normal Skill Damage', 'Ignore Defense Damage', 'Additional Damage', 'Slide Skill Attack', 'Instant Heal', 'Defense'].include?(name)
        txt.gsub!('.', '')
        txt = "<span class=\'skill_detail\'>#{txt}</span>"
        line = line.gsub(name, name + " (#{txt})") if skill_n == name
      end
    end
    line
  end

  def insert_tooltip(line, skill_details = nil, skill_type = nil)

    # line
    # line = line.gsub('<color=ffffff>', '<span class=\'buff_icon\' style=\'color: lightblue;\'>')
    if !skill_details.nil?
      line = fix_skill_description_issue(line, skill_details)
      line = replace_text_color(line)
      line = add_skill_description(line, skill_details, skill_type)
    end
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

end
#### END OF HELPER METHODS #####

def get_gif_ref(word)
  word = word.gsub(/[\^\:']/,'')
  test_word = word.gsub(/[,.]/, '').downcase
  "<img src='/images/stats/#{test_word}.gif' style='max-width: 30px;'></img>"
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
  else
    return nil
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

def fetch_soulcard_yml_data
  yamlf = ''
  if  REGION == 'GLOBAL'
    yamlf = File.expand_path('data/sc/en/soul_cardsEn.yml', __dir__)
  else
    yamlf = File.expand_path('data/sc/jp/soul_cardsJp.yml', __dir__)
  end
  YAML.load_file(yamlf)
end

def fetch_json_data(type)
  if type == 'maindb' && REGION == 'JAPAN'
    JSON.parse(File.read('data/childs/jp/CharacterDatabaseJp.json'))
  elsif type == 'maindb' && REGION == 'GLOBAL'
    JSON.parse(File.read('data/childs/en/CharacterDatabaseEn.json'))
  elsif type == 'reflistdb' && REGION == 'GLOBAL'
    JSON.parse(File.read('data/childs/en/characterRefListEn.json'))
  elsif type == 'reflistdb'
    JSON.parse(File.read('data/childs/jp/characterRefListJp.json'))
  elsif type == 'soulcarddb' && REGION == 'JAPAN'
    JSON.parse(File.read('data/sc/jp/soulcardDatabaseJp.json'))
  elsif type == 'soulcarddb' && REGION == 'GLOBAL'
    JSON.parse(File.read('data/sc/en/soulcardDatabaseEn.json'))
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
    File.expand_path('data/security_log.yml', __dir__)
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
    path = File.join('data/', 'security_log.yml')
    File.open(path, 'wb') { |f| f.write(data) }
  else
    path = File.join('data/', 'history_log.yml')
    File.open(path, 'wb') { |f| f.write(data) }
  end
end

def format_stat(stat_key, info_val)
  info_val = info_val.downcase if info_val == info_val.to_s
  if stat_key == 'stars'
    info_val = info_val.to_s
    # "<img class=\'star_rating\' src='https://res.cloudinary.com/mnyiaa/image/upload/v1583812290/riceminejp/stats/star#{info_val}.png' alt='#{info_val}'stars/>"
    "<img class=\'star_rating\' src='/images/stats/#{info_val}.png' alt='#{info_val}'stars/>"
  elsif %w[defencer attacker supporter healer balancer water fire forest light dark].include?(info_val.downcase)
    # "<img class=\'element-type-pic\' src='https://res.cloudinary.com/mnyiaa/image/upload/v1583812290/riceminejp/stats/#{info_val}.png' alt='#{info_val}'/>"
    "<img class=\'element-type-pic\' src='/images/stats/#{info_val}.png' alt='#{info_val}'/>"
  else
    info_val
  end
end

def upcase_name(name)
  return name.capitalize if !name.include?(" ")
  name.split(' ').map(&:capitalize)[-2..-1].join(' ')
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

# finding data to the untis.

def format_buffs(buff)
  path = '/images/' + buff.gsub('buff_set', 'img/value.png')
  return nil if directory_exists?('public' + path) == false
  return '/images/' + buff.gsub('buff_set', 'img/value.png')
end

def get_buff_icon_text_info(info, icon_only = false)
  buffs = []
  info.each do |k,v|
    buffs << format_buffs(v['icon']) if icon_only
    buffs << [v['name'], v['text'].gsub('.', '')] if !icon_only
  end
  buffs
end

def sort_assign_data(data_dump, reference_list, name, usage = false, ignited = false)
  character = data_dump

  #this x call writes data like tiers and such if unit already exists Can delete when files are uptodatess

  # quick_ref_list_build_from_yaml_and_other_files(character, name)
  # return
  #end
  if usage == 'search'
    assign_search_data(character, name)
  elsif usage == 'profile'
    assign_profile_data(character, reference_list, ignited)
  else
    assign_index_data(character, reference_list, name)
  end
end

def check_and_get_if_profile_exist(query, reference_list, by_idx_num = false)
  ref = ''
  if by_idx_num == false
    query = query.downcase.gsub(" ", "")
    reference_list.each do |k,_|
      if (k['en_name'].downcase.gsub(" ", "") == query ||
        k['kr_name'].downcase.gsub(" ", "") == query ||
        k['jp_name'].downcase.gsub(" ", "") == query)
        ref = k
      end
    end
  else
    query = query.downcase.gsub(" ", "")
    reference_list.each do |k,_|
      if k['idx'] == query
        ref = k
      end
    end
  end
  ref
end

def generate_json_skills(name, code = '', ignited = false)
  data_dump = fetch_json_data('maindb')
  reference_list = fetch_json_data('reflistdb')
  name = name.downcase

  reference_data = check_and_get_if_profile_exist(name, reference_list)
  char_idx_num = reference_data['idx']


  data_dump_idx = data_dump.find_index {|k,_| next if filter_skin_class(k); k['idx'] == char_idx_num || (k['skins'].keys[0][0..4] + '01') == code }

  if data_dump_idx.nil? && char_idx_num.nil?
    session['message'] = "Unit '#{name.upcase}' was not found!"
    redirect '/'
  end
  sort_assign_data(data_dump[data_dump_idx], reference_data, name, 'profile', ignited)
end

#### routes ####
not_found do
  redirect '/'
end

error 400..510 do
  if uri.to_s.include?('images')
    session[:message] = 'Missing IMG!'
  elsif %w(sitemap_index robots.txt ).any? {|k| uri.to_s.include?(k) }
	   return
  else
  	if %w(childs images equips soulcards).any? {|k| uri.to_s.include?(k) }
  		session[:message] = 'Address invalid!'
  	else
  		add_to_history(session[:message] + "--- Status #{status}. (IP: #{request.ip}: Origin: '#{uri}')", true)
  		redirect '/'
  	end
  end
  add_to_history(session[:message] + "--- Error: #{status} --- #{uri.to_s}")
  redirect '/'
end

get '/users/signin' do
  erb :signin
end

get '/' do
  # dump_sc_data_to_ref_list('gl')
  # add_missing_units_names
  # return
  main_db_dump = fetch_json_data('maindb')
  name_ref_list = fetch_json_data('reflistdb')
  sc_ref_list = fetch_json_data('soulcarddb')

  filtered_ref_list = name_ref_list.select do |k|
    next if exclusion_list(k)
    fetched = check_and_get_if_profile_exist(k['idx'], main_db_dump, true)
    fetched.empty? ? false : true
  end


  recent_units = filtered_ref_list.sort_by {|k| [Date.parse(k['date']).to_s, k['en_name']]}#[-5..-1]
  recent_sc = sc_ref_list.sort_by {|k| [Date.parse(k['date']).to_s, k['en_name']]}[-5..-1]

  selected_info = []

  recent_units.each do |unit|
    idx_num = unit['idx']
    data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num && k['grade'] > 4 }

    next if data_dump_idx.nil?

    selected_info << sort_assign_data(main_db_dump[data_dump_idx], unit, unit['en_name'], false) # false to say it isn't for profile
  end

  @unit = selected_info.flatten[-5..-1]

  @soulcards = recent_sc
  erb :home
end

get '/guides/howto' do
  erb :howto
end

get '/log/:type' do
  require_user_signin
  type = params[:type]
  redirect '/' if (type != 'search' && type != 'history' && type != 'security')

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

  main_db_dump = fetch_json_data('maindb')
  name_ref_list = fetch_json_data('reflistdb')
  selected_info = search_data_for_keywords(main_db_dump, name_ref_list, words)
  found_by_name = []
  found_by_stats = []

  selected_info[0].each do |unit|
    next if unit.nil?
    idx_num = unit['idx']
    data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
    next if data_dump_idx.nil?
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
  redirect "/tiers/5" if !['3','4','5'].include?(stars)

  @tiers = %w(10 9 8 7 6 5 4 3 2 1 0)
  @sorted_by = %w(PVE PVP RAID WORLDBOSS)

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
  redirect '/soulcards/5' if !['3','4','5'].include?(stars)

  sc_ref_list = fetch_json_data('soulcarddb')
  sc_ref_list = sc_ref_list.select {|k| k['grade'] == stars.to_i}
  recent_sc = sc_ref_list.sort_by {|k| [k['date'],k['en_name']]}.reverse

  @soulcards = recent_sc
  erb :soulcard_index
end

get '/sort/:stars/:sorting' do
  order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
  stars = params[:stars]
  sorting = params[:sorting]

  unless %w(element type date).include?(sorting) && (stars.to_i > 2 && stars.to_i < 6)
    redirect '/sort/5/date'
  end

  selected_info = case stars
  when '3'
    sort_grab_by_stars('3')
  when '4'
    sort_grab_by_stars('4')
  when '5'
    sort_grab_by_stars('5')
    # find_missing_units_not_in_ref_list('5')
  end

  @sorted_by = if sorting == 'element'
    ['water', 'fire', 'forest', 'light', 'dark']
  elsif sorting == 'type'
    ['attacker', 'healer', 'balancer', 'supporter', 'defencer']
  elsif sorting == 'date'
    x = []
    selected_info.flatten.each do |k|
      x << Date.parse(k['date']).to_s
    end
    x.uniq.sort.reverse
  end

  @unit = selected_info
  erb :child_index
end

get '/sort2/:stars/:sorting' do
  #delete when fixed
  order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
  stars = params[:stars]
  sorting = params[:sorting]

  selected_info = find_missing_units_not_in_ref_list('5')

  @sorted_by = if sorting == 'element'
    ['water', 'fire', 'forest', 'light', 'dark']
  elsif sorting == 'type'
    ['attacker', 'healer', 'balancer', 'supporter', 'defencer']
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

  @char_info, @mainstats, @substats, @buffs, @skill_details, @pics, @ignited  = @generated_info

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

  @char_info, @mainstats, @substats, @buffs, @skill_details, @pics  = @generated_info

  erb :view_unit_ignited
end

get '/new/unit_new' do
  require_user_signin

  one = %w(idx code en_name jp_name kr_name tiers notes date)
  @transfered_data = {}
  if !params[:data].nil?
   param = JSON.parse(params[:data])
     @transfered_data['en_name'],
     @transfered_data['idx'],
     @transfered_data['code'],
     @transfered_data['grade'] = param
  end
  @new_profile = (one)

  @profile_pic_table = %w(image1 image2 image3)

  main_db_dump = fetch_json_data('maindb')
  name_ref_list = fetch_json_data('reflistdb')

  erb :new_unit
end


get '/new/unit_db_data' do
  require_user_signin

  one = JSON.parse(new_unit_data_template.to_json)

  @new_profile = (one)
  #
  # main_db_dump = fetch_json_data('maindb')
  # name_ref_list = fetch_json_data('reflistdb')

  erb :new_unit_db
end

get '/new/equips/new_sc' do
  require_user_signin
  @new_profile = %w(idx dbcode grade code jp_name kr_name normalstat1 normalstat2 prismstat1 prismstat2 restriction ability notes date)
  @profile_pic_table = ['pic']
  @max_idx = fetch_json_data('soulcarddb').map {|k| k['dbcode']}.max + 1

  erb :new_sc
end

get '/edit_unit/:unit_name' do
  require_user_signin
  name = params[:unit_name].downcase
  main_db_dump = fetch_json_data('maindb')
  name_ref_list = fetch_json_data('reflistdb')
  ref_profile = check_and_get_if_profile_exist(name, name_ref_list)
  redirect '/' if ref_profile.empty?

  index = main_db_dump.find_index {|k,_| k['idx'] == ref_profile['idx'] }

  data = main_db_dump[index]
  @new_profile = ref_profile
  @code = data['skins'].keys[0]

  @profile_pic_table = {'image1' => ref_profile['image1'], 'image2' => ref_profile['image2'], 'image3' => ref_profile['image3']}
  erb :edit_unit
end

get '/edit_unit_db/:unit_name' do
  require_user_signin
  name = params[:unit_name].downcase
  main_db_dump = fetch_json_data('maindb')
  name_ref_list = fetch_json_data('reflistdb')
  ref_profile = check_and_get_if_profile_exist(name, name_ref_list)
  redirect '/' if ref_profile.empty?

  index = main_db_dump.find_index {|k,_| k['idx'] == ref_profile['idx'] }

  data = main_db_dump[index]

  keys = %w(idx name attribute role grade code skills skills_ignited)
  @name = name
  @new_profile = {}
  data.each do |key, val|
    @new_profile[key] = val if keys.include?(key) && (key != 'skills' || key != 'skills_ignited')
    @new_profile[key] = get_skill_text_only(val) if (key == 'skills' || key == 'skills_ignited')
  end
  @code = data["skins"]

   @profile_pic_table = {}#{'image1' => ref_profile['image1'], 'image2' => ref_profile['image2'], 'image3' => ref_profile['image3']}
  erb :edit_unit_db
end

get '/edit_sc/:sc_name' do
  require_user_signin
  session[:message] = 'Currently can\'t edit soulcards. Will fix soon.'
  redirect '/'

  name = params[:sc_name].gsub("'", "''").downcase
  data = []

  one = []
  # data = reload_database
  @new_profile = one
  # binding.pry
  @profile_pic_table = []
  erb :edit_sc
end

get '/unit_edit_list' do

  @unit = sort_grab_by_stars('all').flatten

  erb :unit_edit_list
end

get '/sc_edit_list' do
  sc_ref_list = fetch_json_data('soulcarddb')
  recent_sc = sc_ref_list.sort_by {|k| [Date.parse(k['date']).to_s,k['en_name']]}.reverse

  @soulcards = recent_sc
  erb :sc_edit_list
end

get '/unit_details_get' do
  units = sort_grab_by_stars('all').flatten

  @units = units.map { |unit| unit['en_name'].capitalize }.sort_by { |k| k }


    sc = fetch_json_data('soulcarddb')

    @sc = sc.map { |sc| sc['en_name'].capitalize }.sort_by { |k| k }
    @region = if REGION == "GLOBAL"
                'En'
              else
                'Jp'
              end
  erb :show_unit_details
end

get '/files/:type' do
  redirect '/'
  require_user_signin
  type = params[:type]

    erb :file_list
end


get '/download/:filename' do |filename|
require_user_signin
  sub_path = (REGION == "JAPAN" ? 'jp' : 'en')
  fname = filename
  ftype = 'Application/octet-stream'
  # checked_fname = filename.split('').map(&:to_i).reduce(&:+) == 0
  if filename.include?('soul')
    send_file "./data/sc/#{sub_path}/#{fname}", filename: fname, type: ftype
  elsif filename.include?('RefList') || filename.include?('Database')
    send_file "./data/childs/#{sub_path}/#{fname}", filename: fname, type: ftype
  end
  redirect '/'
end

get '/:type/:name' do  #remove a unit/soulcard
  unless %w(sc_remove unit_remove).include?(params[:type])
    redirect '/'
  end

  require_user_signin

  type = params[:type]
  name = params[:name]

  if type == 'sc_remove'
    remove_soulcard(name)
    session[:message] = "SoulCard #{name.upcase} has successfully been removed!"

    redirect '/sc_edit_list'
  else
    remove_unit(name)
    session[:message] = "Unit #{name.upcase} has successfully been removed!"
    redirect '/unit_edit_list'
  end

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

    add_to_history("Sign-in Sueccessful -- (IP: #{request.ip}: Origin: '#{uri}')", true) unless request.ip.to_s == '131.147.5.28'
    redirect '/'
  else
    session[:message] = 'Invalid credentials!'
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
  params['date'] = new_time.to_date.to_s if params['date'].empty?

  params.each do |k, v|
    next if %w(fileimage1 fileimage2 fileimage3 current_unit_name edited enabled tooltip skill_dump).include?(k)
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

  if REGION == "JAPAN"
    File.open('data/childs/jp/characterRefListJp.json', 'w') { |file| file.write(name_ref_list.to_json) }
  else
    File.open('data/childs/en/characterRefListEn.json', 'w') { |file| file.write(name_ref_list.to_json) }
  end

  redirect "/unit_edit_list"
end

post '/new_unit_data' do
  require_user_signin

  main_db = fetch_json_data('maindb')

  name = ''
  idx = params['idx']
  new_unit = nil
  if (main_db.any? { |k| k['idx'] == idx } && params['new_unit'] == 'true')
    session['message'] = 'That idx / Unit already exists.'
    redirect '/new/unit_db_data'
  elsif (main_db.any? { |k| k['idx'] == idx } && params['edited_unit'] == 'on')
    name = params['name']
    idx_of_arr_data = main_db.find_index {|k,_| k['idx'] == params['idx'] }
    new_unit = main_db[idx_of_arr_data]
  else
    name = params['en_name']
    new_unit = JSON.parse(new_unit_data_template.to_json)
  end

  params.each do |k, v|
    next if %w(current_unit_name edited_unit).include?(k)
    case k
    when 'en_name'
      new_unit['name'] = name
    when 'idx'
      new_unit['idx'] = idx
    when 'code'
      if v.include?('{')
        new_unit['skins'] = JSON.parse v.gsub('=>', ':')
      elsif !v.include?('{') && v.include?(',')
        v = v.gsub(" ", "").split(",")
        v.each {|cde| new_unit['skins'][cde] = name }
        params['code'] = v[0]
      else
        new_unit['skins'][params['code']] = name
      end
    when 'role'
      new_unit['role'] = v
    when 'attribute'
      new_unit['attribute'] = v
    when 'grade'
      v = 5 if v.to_i == 0
      new_unit['grade'] = v.to_i
    end
  end

  params.each do |k, v|
    next if %w(current_unit_name edited_unit).include?(k)
    case k.split('@')[0]
    when 'skills'
      new_unit[ k.split('@')[0]][k.split('@')[1]]['text'] = v
    when 'skills_ignited' && k != []
      new_unit[ k.split('@')[0]][k.split('@')[1]]['text'] = v
    end
  end

  sort_order = [:idx, :name, :attribute, :role, :grade, :status, :skins, :skills, :skills_ignited]
  new_unit = new_unit.sort_by { |k, _| sort_order.index(k.to_sym) }.to_h
  if params['new_unit'] == 'true'
    main_db << new_unit
  elsif params['edited_unit'] == 'on'
    main_db[idx_of_arr_data] = new_unit
  end




  session[:message] = "New unit called #{name.upcase} has been created."
  add_to_history("New unit called #{name.upcase} has been created.")
  puts "-- Updated Unit '#{name.upcase}' Profile! --"

  if REGION == "JAPAN"
    File.open('data/childs/jp/CharacterDatabaseJp.json', 'w') { |file| file.write(main_db.to_json) }
  else
    File.open('data/childs/en/CharacterDatabaseEn.json', 'w') { |file| file.write(main_db.to_json) }
  end

# the following will redirect to ref list if data is created without ref link existing.(makes it easier)
  reference_list = fetch_json_data('reflistdb')
  checked = check_and_get_if_profile_exist(idx, reference_list, true)
  if params['new_unit'] == 'true' && (checked.empty? || checked.nil?)

    unitdata = "#{[name, idx, params['code'], params['grade']]}"
    # session[:unitdata] = unitdata
    redirect to("/new/unit_new?data=#{unitdata}")
  else
    redirect "/unit_edit_list"
  end
end

post '/new_sc' do
  require_user_signin

  original_name = !params[:current_sc_name].nil? ? params[:current_sc_name].gsub("'", "\'").downcase : ''

  sc_ref_list = ''
  yml_path = ''
  json_file_path = ''
  image = ''

  if REGION == 'JAPAN'
    sc_ref_list = fetch_json_data('soulcarddb')
    json_file_path = 'data/sc/jp/soulcardDatabaseJp.json'
    yml_path = 'data/sc/jp/soul_cardsJp.yml'
    image = create_file_from_upload(params[:file], params[:pic], 'public/images/sc/jp') unless params[:pic].nil?
  else
    sc_ref_list = fetch_json_data('soulcarddb')
    json_file_path = 'data/sc/en/soulcardDatabaseEn.json'
    yml_path = 'data/sc/en/soul_cardsEn.yml'
    image = create_file_from_upload(params[:file], params[:pic], 'public/images/sc/gl') unless params[:pic].nil?
  end

  card_data = YAML.load_file(File.expand_path(yml_path, __dir__))

  name = params[:sc_name].gsub("'", "\'").downcase
  sc_id = params['dbcode'].to_i

  created_on = params['date']
  # image = params[:pic].gsub(/[\s\'_]/, "")
  check_enabled = (params[:enabled].to_i == 1) ? 't' : 'f'
  new_time = Time.now.utc.localtime('+09:00')
  created_on = ([new_time.year, new_time.month, new_time.day].join('-')).to_date.to_s if created_on.empty?

  new = {}

  new['pic'] = image.empty? ? '/images/sc/jp/afternoontrain.jpg' : image
  new['enabled'] =  'true'
  new['stars'] =  params[:grade].to_s
  new['normal'] = [format_new_sc_stats(params[:normalstat1]), format_new_sc_stats(params[:normalstat2])]
  if !params[:prismstat1].nil?
    new['prism'] = [format_new_sc_stats(params[:prismstat1]), format_new_sc_stats(params[:prismstat2])]
  end
  restrict = 'restriction ' + params[:restriction]
  ability = 'ability ' + params[:ability]
  passive = [restrict, ability].flatten.join(" ")
  new['passive'] = format_new_sc_stats(passive, true)
  new['index'] = params[:dbcode].to_i

  if card_data[name] && card_data[name]['index'].to_i != params['idx'].to_i
    name = name + '2'
    card_data[name] = new
  else
    card_data[name] = new
  end

  File.write(yml_path, YAML.dump(card_data))

  dmp = {
    "idx"=> params['idx'],
    "dbcode"=>params['dbcode'].to_i,
    "grade"=>params['grade'].to_i,
    "code"=>params['code'],
    "en_name"=>name,
    "jp_name"=>params['jp_name'],
    "kr_name"=>params['kr_name'],
    "image1"=>image.empty? ? '/images/sc/jp/afternoontrain.jpg' : image,
    "notes"=>params['notes'],
    "date"=>created_on
  }
  sc_ref_list << dmp
  File.open(json_file_path, 'w') { |file| file.write(sc_ref_list.to_json) }

  session[:message] = "New soulcard called #{name.upcase} has been created."
  add_to_history("New soulcard called #{name.upcase} has been created.")
  puts "-- Updated Unit Profile! --"
  redirect "/sc_edit_list"
end

post '/uploadlocal' do
  require_user_signin
  unless params[:file] &&
    (tmpfile = params[:file][:tempfile]) &&
    (name = params[:file][:filename])
    session[:message] = 'No file selected'
    redirect '/upload_file'
  end
  if %w(.rar .js .lua .php).any? { |ftype| params['file']['type'].include?(ftype) }
    session[:message] = 'Not a valid file-type'
    redirect '/upload_file'
  end


binding.pry
  directory =
  if ['history_log.yml', 'search_log.yml'].include?(name)
    'data/'
  elsif name.include?('soul_cards')
    'data/'
  elsif name.include?('.css')
    'public/stylesheets/'
  elsif name.include?('full')
    'public/images/full/'
  elsif name.include?('.png')
    'public/images/portraits/' if params['full_image'] == '0'
    # 'public/portraits/' if params['full_image'] == '1'
  elsif name.include?('.jpg') || params['soulcard_image'] == '0'
    REGION == 'JAPAN' ? 'public/images/sc/jp/' : 'public/images/sc/gl/'
  elsif name.include?('.gif')
    'public/images/stats/'
  else
    session[:message] = 'Not a valid file-type'
    redirect '/upload_file'
  end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  session[:message] = 'file uploaded!'
  add_to_history("File uploaded: #{name}")


  redirect '/upload_file'
end
