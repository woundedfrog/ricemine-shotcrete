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
require 'uri'
require 'net/http'
require 'benchmark'

require_relative 'formatnamelist'
require_relative 'formatsoulcards'

include FormatNameList
include FormatSoulCards

REGION = "GLOBAL"

configure do
  set :erb, escape_html: true
  enable :sessions
  set :sessions, :expire_after => 3600
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

end

def require_user_signin
  return unless user_signed_in? == false

  puts  "#{request.ip}: origin: #{uri}"
  session[:message] = 'You don\'t have access to that.'

  add_to_history("Sign-in attempt -- Status #{status}. (IP: #{request.ip}: Origin: '#{uri}')", 'security') unless request.ip.to_s == '131.147.5.28'
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

  def get_image_link(image_n, backup = nil)
    db = fetch_json_data('soulcarddb')
    path = '/images/sc/' + db[image_n]['view_idx'] + '.jpg'
    path2 = '/images/sc/' + db[image_n]['view_idx'] + '.png'

    if File.file?('public/' + path)
      path
    elsif File.file?('public/' + path2)
      path2
    else
      if REGION == 'JAPAN'
        backup = backup.gsub("/images/sc", '/images/sc/jp') unless backup.include?('/jp/')
      elsif REGION == 'GLOBAL'
        backup = backup.gsub("/images/sc", '/images/sc/en') unless backup.include?('/en/')
      end
        backup
    end
  end

  def get_img_link(name, list = false)
    # this gets the full-size image for a link and send placeholder if not found.
    # ../../../images/full_size/full<%= @name.gsub(/\s+/, "")

    # name = name.split(" ")[-2..-1].join(" ")
    name = name.downcase.gsub(/[^a-z]/i, '')
    name = 'full' + name.gsub(/\s+/, "")

    return "/images/full/fullmissingpic1.png"

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
    # adds gifs and links to other units.
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
            ["Chance for <color=ffffff>Awakening</color>", "Chance to apply <color=ffffff>Awakening</color>"],
            ["<color=ffffff>固定ダメージ</color>", "<color=ffffff>Fixed damage</color>"],
            ['Debuff Poison Only Allies', 'Bleed Debuffed Allies'],
            ['Priority Highest', 'Highest'],
            ['Priority Lowest', 'Lowest']].to_h
    else
      fix = [['Vampirism for', '<color=ffffff>Vampirism</color> for'],
            ['Debuff Poison Only Allies', 'Bleed Debuffed Allies'],
            ['Priority Highest', 'Highest'],
            ['Priority Lowest', 'Lowest']].to_h
    end

    if REGION == 'JAPAN'
      if !line.include?('<color=')
        skill_details.each do |key, val|
          val.each do |k,v|
              skill_n = k
              description = v
              if line.downcase.include?(skill_n.downcase)
                  line = line.gsub(/#{skill_n}/i, " <color=ffffff>#{skill_n}</color> ")

            end
          end
        end
      end
      fix.each do |key, val|
        if line.include?(key)
          # 'fixed skill line wording'
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
              fix.each do |key, val|
                if line.include?(key)
                  p 'fixed skill line'
                  line = line.gsub(key, val)
                end
              end
          end
        end
      end
    end

    line
  end

  def replace_text_color(line, skill_details = false, skill_type = false)
    # some skill replacements end up missing a space after the color code is added. makes is squished.
    # could filder all ending spaces+ and replace with single space.
    # strings are split in view_unit_normal by (/\.\s*^\)/)
  x = line + '!'
  return line if skill_details[skill_type + '_skill_detail'].nil? || skill_type == 'auto'

     if line.include?("<color") == false || REGION == "GLOBAL"
       skill_details[skill_type + '_skill_detail'].each do |s_n,s_d|
           #skill renaming is for global skills that have different names than skill names
           s_n = "Skill Gauge Charge Speed" if s_n == "Skill Charge Acceleration"
           s_n = "Ignore DEF Damage" if s_n == "Penetrate"
            line = line.gsub(s_n, "<color=ffffff>#{s_n}</color> ") unless line.include?("<color=ffffff>#{s_n}</color>")
            line = line.gsub(/\s+/, ' ')
       end
     end

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

  def translate_if_needed(name, txt)
    skills = [['気絶', 'Faint'],
  ['クリティカル時スキルゲージチャージ', 'Skill gauge charge on crit']]
      descriptions = [['スキルゲージ初期化＆行動不可(気絶状態で攻撃を受けると維持時間を1秒ずつ追加、最大5秒)', 'Skill gauge freezes & unable to act (extends time by 1 second each when attacked in a stunned state, maximum 5 seconds)'],
    ['味方の回復スキルがクリティカルになった場合、該当味方のスキルゲージを一定量チャージ', 'When ally with regen crits, skill gauge charges']]

          skills.each do |arr|
            if arr[0] == name
              name = arr[1]
            end
          end
          descriptions.each do |arr|
            if arr[0] == txt
              txt = arr[1]
            end
          end
          [name, txt]
  end

  def add_skill_description(line, skill_details, skill_type)
    regex = /(?<=\>)(.*?)(?=\<)/
    skill_n = line[regex, 1]
    skill_type += "_skill_detail"
    return line if skill_n.nil? || skill_type.include?("auto")
    skill_details[skill_type].uniq.each do |info|
      [info].to_h.each do |name, txt|
        next if ['Normal Skill Damage', 'Ignore Defense Damage', 'Additional Damage', 'Slide Skill Attack', 'Instant Heal', 'Defense'].include?(name)
        next if (%w(Stun).include?(name) && REGION == 'GLOBAL')
        new_name, txt = translate_if_needed(name, txt) if name.match?(/[\u4e00-\u9faf]/)
        new_name = name if new_name.nil?
        txt = txt.gsub('.', '')
        new_txt = "<span class=\'skill_detail\'>#{txt}</span>"
        line = line.gsub(name, new_name + " (#{new_txt})") if skill_n == name
      end
    end
    line
  end

  def insert_tooltip(line, skill_details = nil, skill_type = nil)

    # line
    # line = line.gsub('<color=ffffff>', '<span class=\'buff_icon\' style=\'color: lightblue;\'>')
    if !skill_details.nil?
      line = fix_skill_description_issue(line, skill_details)
      line = replace_text_color(line, skill_details, skill_type)
      line = add_skill_description(line, skill_details, skill_type)
    end
    return line
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
  # word = word.gsub(/[\$\']/,'').gsub("_", " ")
    word = word.gsub(/[^a-zA-Z\_]/,'').gsub("_", " ")
  test_word = word.gsub(/[,.]/, '').downcase
  found_name = ''
  if names.map(&:downcase).each do |n|
    found_name = n if n.gsub(/[^a-z\s]/,'') == test_word.downcase

  end
    p found_name = found_name.gsub(/[\']/,'')
    "<a class=\'linkaddress\' href=\'/childs/5stars/#{found_name}\' style=\'color: #efff00;\'>#{found_name.upcase}</a>"
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
    if directory.include?("/sc")
      pname = 'pcmissing.jpg'
      return pname
    else
      pname = 'emptyunit0.png'
    end
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
  locale = REGION == 'JAPAN' ? 'jp' : 'en'
  if type == 'maindb'
    JSON.parse(File.read("data/childs/CharacterDatabase#{locale.capitalize}.json"))
  elsif type == 'reflistdb'
    JSON.parse(File.read("data/childs/characterRefList#{locale.capitalize}.json"))
  elsif type == 'soulcardref'
      JSON.parse(File.read("data/sc/soulcardRefList#{locale.capitalize}.json"))
  elsif type == 'soulcarddb'
      JSON.parse(File.read("data/sc/SoulCartas#{locale.capitalize}.json"))
  end
end



def backup_tooltips(tooltip)
  date = DateTime.now.strftime("%d-%m-%Y-%Hh%Mm")
  FileUtils.cp('data/tooltips.yml', "data/ymlbackup/" + date +'-tooltips.yml')

  path = File.join('data/', 'tooltips.yml')
  File.open(path, 'wb') { |f| f.write(tooltip) }

end

def find_replace_history_entry(data, new_log)
  data = data.map do |entry|
          entry unless entry.include?(new_log)
        end.compact
end

def add_to_history(info, type)
	return if info.include?('apple-touch') || request.ip == '127.0.0.1'
  path = if type == 'security'
    File.expand_path('data/security_log.yml', __dir__)
  elsif type == 'error'
    File.expand_path('data/error_log.yml', __dir__)
  elsif type == 'history'
    File.expand_path('data/history_log.yml', __dir__)
  elsif type == 'search'
    File.expand_path('data/search_log.yml', __dir__)
  end

  data = YAML.load_file(path)

  if data.size >= 200
    data.shift(10)
    new_log = Time.now.utc.localtime('+09:00').to_s + " [#{info}]"
  else
    new_log = Time.now.utc.localtime('+09:00').to_s + " [#{info}]"
  end


  data = find_replace_history_entry(data, info)
  data << new_log unless data.include?(new_log)

  # if search
    # path = File.join('data/', 'security_log.yml')
    # File.open(path, 'wb') { |f| f.write(data) }
  # else
    # path = File.join('data/', 'history_log.yml')
    File.open(path, 'wb') { |f| f.write(data) }
  # end
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

def sort_assign_data(data_dump, reference_char, name, usage = false, ignited = false)
  character = data_dump

  #this x call writes data like tiers and such if unit already exists Can delete when files are uptodatess

  # quick_ref_list_build_from_yaml_and_other_files(character, name)
  # return
  #end
  if usage == 'search'
    assign_search_data(character, name)
  elsif usage == 'profile'
    assign_profile_data(character, reference_char, ignited)
  else
    assign_index_data(character, reference_char, name)
  end
end

def check_and_get_if_profile_exist(query, reference_list, by_idx_num = false)
  ref = ''
  if by_idx_num == false
    query = query.downcase.gsub(" ", "")
    reference_list.each do |k,_|
      if (k['en_name'].downcase.gsub(" ", "").gsub("'",'') == query.gsub(" ", "").gsub("'",'') ||
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
  name = reference_data["en_name"]

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
  session[:message] = session[:message].nil? ? '' : session[:message]
  if uri.to_s.include?('images')
    session[:message] = 'Missing IMG!'
  elsif %w(sitemap_index robots.txt ).any? {|k| uri.to_s.include?(k) }
	   return
  else
  	if %w(childs images equips soulcards).any? {|k| uri.to_s.include?(k) }
  		session[:message] = 'Address invalid!'
  	else
  		add_to_history(session[:message] + "--- Status #{status}. (IP: #{request.ip}: Origin: '#{uri}')", 'error')
  		redirect '/'
  	end
  end
  add_to_history(session[:message] + "--- Error: #{status} --- #{uri.to_s}", 'error')
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
  sc_ref_list = fetch_json_data('soulcardref')

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

get '/guides/:page' do

  case params['page']
  when 'howto'
    erb :howto
  when 'links'
    erb :links_page
  else
    session['message'] = 'Sorry that page does not exist.'
    redirect '/'
  end
end

get '/dump/:type/true' do
  type = params[:type]
  if type == 'dbbuffdump'
    dump_buff_details_to_file
    session[:message] = "Created new buff db file for skills creation"
  end
  redirect '/'
end

get '/pics/show_buff_icons' do
  region = REGION == "JAPAN" ? 'Jp' : 'En'
  buff_db = JSON.parse(File.read("./data/childs/BuffsInfo#{region.capitalize}.json"))
  @icons = {}
  buff_db.each do |b|
    idx = b['idx'].nil? ? 'noidx' : b['idx']
    name = b['name'].nil? ? 'none' : b['name']
    @icons[idx] = {'name' => name, 'path' => b['icon']}
  end
  erb :buff_icons
end

get '/log/:type' do
  require_user_signin
  type = params[:type]
  redirect '/' if (type != 'search' && type != 'history' && type != 'security' && type != 'error')

  path = File.expand_path("data/#{type}_log.yml", __dir__)
  @history = YAML.load_file(path)

  # path = File.expand_path('data/basics.md', __dir__)
  @type = type
  erb :history
end

get '/search-results/' do
  redirect '/' if params[:search2].nil? || params[:search2].empty?
  words = params[:search2].downcase
   add_to_history("Search: #{words}", 'search')
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

get '/tiers/:stars/ignited' do
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

  erb :child_tiers_ign
end

get '/soulcards' do
  redirect '/soulcards/5'
end

get '/soulcards/:stars/:name' do
  name = params[:name].gsub("'", "\'")

  # @soulcard = sc_data_from_yml(name)
  @name = name
  @soulcard = filter_grab_soulcard_data(name)
  @soulcard_prism = params[:stars] == '5' ? filter_grab_soulcard_data(name, true) : {}
  erb :view_sc
end

get '/soulcards/:stars/prism/:name' do
  name = params[:name].gsub("'", "\'")

  @soulcard = sc_data_from_yml(name)

  @soulcard = filter_grab_soulcard_data(name, true)
  erb :view_sc_prism
end

get '/soulcards/:stars' do
  stars = params[:stars]
  redirect '/soulcards/5' if !['3','4','5'].include?(stars)

  sc_ref_list = fetch_json_data('soulcardref')
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
  ######### fetches all existing IDX
  reflist = fetch_json_data('reflistdb')
  idxs = []
  reflist.each do |val|
                  idxs << val['idx'] unless idxs.include? val['idx']
                  idxs << val['idx2'] unless (val['idx2'] == '' || idxs.include?(val['idx2']) )
                end
  @idxs = idxs
  #########

  erb :new_unit_db
end

get '/new/equips/new_sc' do
  require_user_signin
  @new_profile = %w(idx dbcode code grade jp_name kr_name normalstat1 normalstat2 prismstat1 prismstat2 restriction ability notes date)
  @profile_pic_table = ['pic']

  @max_idx = fetch_json_data('soulcardref').map {|k| k['dbcode'].to_i }.max + 1


    ######### fetches all existing IDX
    reflist = fetch_json_data('soulcardref')
    idxs = []
    reflist.each do |val|
                    idxs << val['idx'] unless idxs.include? val['idx']
                    idxs << val['idx2'] unless (val['idx2'] == '' || idxs.include?(val['idx2']) )
                  end
    @idxs = idxs
    #########

  erb :new_sc
end

get '/edit_sc_db/:name' do
  require_user_signin

  # @soulcard = sc_data_from_yml(name)
  @name = params[:name].gsub("'", "\'")
  @soulcard = filter_grab_soulcard_data(@name)

  @soulcard_prism = filter_grab_soulcard_data(@name, true)

  @profile_pic_table = ['pic']
  @max_idx = 'nil'

  hash = {}

  @soulcard.each do |k,v|
    next if ['options_max','options', 'status_max'].include?(k)
    case k
    when 'status'
      hash['normalstat1'] = (v.to_a[0] << @soulcard['status_max'].to_a[0][1])
      hash['normalstat2'] = (v.to_a[1] << @soulcard['status_max'].to_a[1][1])
      unless @soulcard_prism == {} || @soulcard_prism.nil?
        hash['prismstat1'] = (v.to_a[0] << @soulcard_prism['status_max'].to_a[0][1])
        hash['prismstat2'] = (v.to_a[1] << @soulcard_prism['status_max'].to_a[1][1])
      end
    when 'text'
      hash['ability'] = v
    else
      hash[k] = v
    end
  end

  @new_profile = hash

    ######### fetches all existing IDX
    reflist = fetch_json_data('soulcardref')
    idxs = []
    reflist.each do |val|
                    idxs << val['idx'] unless idxs.include? val['idx']
                    idxs << val['idx2'] unless (val['idx2'] == '' || idxs.include?(val['idx2']) )
                  end
    @idxs = idxs
    ########


  erb :edit_sc_db
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
  if @new_profile['skills_ignited'] == {}
    @new_profile['skills_ignited'] = add_empty_ignited_skill
  end

  @code = data["skins"]

   @profile_pic_table = {}#{'image1' => ref_profile['image1'], 'image2' => ref_profile['image2'], 'image3' => ref_profile['image3']}
  erb :edit_unit_db
end

get '/edit_sc/:sc_name' do
  require_user_signin
  reflist =  fetch_json_data('soulcardref')
  data = []
  name = params[:sc_name].gsub("'", "\'")

  idx = reflist.find_index {|n| n['en_name'].downcase == name.downcase}
  soulcard = reflist[idx]

  @new_profile = soulcard

  @profile_pic_table = {'pic'=>soulcard['image1']}
  erb :edit_sc
end

get '/unit_edit_list' do
  redirect '/unit_edit_list/5'
end

get '/unit_edit_list/:stars' do

  if params[:stars] == 'date'

    @unit = sort_grab_by_stars('all', 'show_all').flatten

    erb :unit_edit_list_date
  else

    stars = params[:stars]

    @tiers = %w(10 9 8 7 6 5 4 3 2 1 0)
    @sorted_by = %w(PVE PVP RAID WORLDBOSS)

    order = params[:sorting] == 'date' ? 'DESC' : 'ASC'
    stars = params[:stars]
    sorting = params[:sorting]

    selected_info = case stars
    when '3'
      sort_grab_by_stars('3', 'show_all')
    when '4'
      sort_grab_by_stars('4', 'show_all')
    when '5'
      sort_grab_by_stars('5', 'show_all')
    end

    @unit = selected_info


    erb :unit_edit_list
  end
end

get '/sc_edit_list' do
  sc_ref_list = fetch_json_data('soulcardref')
  recent_sc = sc_ref_list.sort_by {|k| [Date.parse(k['date']).to_s,k['en_name']]}.reverse

  @soulcards = recent_sc
  erb :sc_edit_list
end

get '/unit_details_get' do
  units = sort_grab_by_stars('all', 'show_all').flatten

  @units = units.map { |unit| unit['en_name'].capitalize }.sort_by { |k| k }


    sc = fetch_json_data('soulcardref')

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
  folder = ''
  if filename.downcase.include?('soul')
    folder = 'sc'
  elsif filename.downcase.include?('character')
    folder = 'childs'
  end
    send_file "./data/#{folder}/#{sub_path}/#{fname}", filename: fname, type: ftype
  # elsif filename.include?('RefList') || filename.include?('Database')
  #   send_file "./data/childs/#{sub_path}/#{fname}", filename: fname, type: ftype
  # end
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
    redirect '/unit_edit_list/5'
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

    add_to_history("Sign-in Sueccessful -- (IP: #{request.ip}: Origin: '#{uri}')", 'security') unless request.ip.to_s == '131.147.5.28'
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
  original_name = !params[:current_unit_name].nil? ? params[:current_unit_name].gsub(/[\']+/, "\'").downcase : ''
  updated_unit_name = params['en_name'].empty? ? original_name : params['en_name']
  idx = params['idx']
  idx_of_arr_data = name_ref_list.find_index {|k,_| k['idx'] == idx }
  updated_unit = {}

  new_time = Time.now.utc.localtime('+09:00')
  params['date'] = new_time.to_date.to_s if params['date'].empty?

  params.each do |k, v|
    next if %w(fileimage1 fileimage2 fileimage3 current_unit_name edited tooltip skill_dump).include?(k)
    if k == 'en_name' && v.empty?
      updated_unit[k] = original_name
    elsif k == 'enabled'
      updated_unit[k] = params['enabled'].downcase == '1' ? 't' : 'f'
    else
      updated_unit[k] = v
    end
  end
  updated_unit['tiers2'] = '0 0 0 0' if updated_unit['tiers2'].nil?

  sort_order = [:idx, :code, :en_name, :jp_name, :kr_name, :image1, :image2, :image3, :tiers, :tiers2, :notes, :date, :enabled]
  updated_unit = updated_unit.sort_by { |k, _| sort_order.index(k.to_sym) }.to_h

  if idx_of_arr_data.nil?
    name_ref_list << updated_unit
  else
    name_ref_list[idx_of_arr_data] = updated_unit
  end

  if params['edited'] == 'on'
    session[:message] = " -- Profile Ref Updated: #{updated_unit_name.upcase}"
    add_to_history(" -- Profile Ref Updated: #{idx} -- #{updated_unit_name.upcase}.", 'history')
  else
    session[:message] = " -- Profile Ref Created: #{updated_unit_name.upcase}"
    add_to_history(" -- Profile Ref Created: #{idx} -- #{updated_unit_name.upcase}.", 'history')
  end
  puts "-- Updated Unit '#{updated_unit_name}' Profile Ref!"

  if REGION == "JAPAN"
    File.open('data/childs/characterRefListJp.json', 'w') { |file| file.write(name_ref_list.to_json) }
  else
    File.open('data/childs/characterRefListEn.json', 'w') { |file| file.write(name_ref_list.to_json) }
  end

  redirect "/unit_edit_list"
end

post '/new_unit_data' do
  require_user_signin

  main_db = fetch_json_data('maindb')

  name = ''
  idx = params['idx']
  new_unit = nil

  if (main_db.any? { |k| k['idx'] == idx } && params['new_unit'] == 'true')  # checks if the id exits while having a different name
    session['message'] = 'That idx / Unit already exists.'
    redirect '/new/unit_db_data'
  elsif (main_db.any? { |k| k['idx'] == idx } && params['edited_unit'] == 'on') # if id matches and is edited
    name = params['name']
    idx_of_arr_data = main_db.find_index {|k,_| k['idx'] == params['idx'] }
    new_unit = main_db[idx_of_arr_data]
  else  # completely new unit
    name = params['en_name']
    new_unit = JSON.parse(new_unit_data_template.to_json)
  end

  name = name.split(" ").map(&:capitalize).join(" ")  # this capitalizes the name. Not needed, but why not

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
        params['code'] = v == '' ? 'c999_01' : v
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
    next if %w(current_unit_name edited_unit).include?(k) || !k.include?('@')
    case k.split('@')[0]
    when 'skills'
      skill_buff = grab_buff_details(new_unit[ k.split('@')[0]][k.split('@')[1]]['buffs'], v)  # gets buff data from new skills
      new_unit[ k.split('@')[0]][k.split('@')[1]]['text'] = skill_buff[0]  # assigns skill names
      new_unit[ k.split('@')[0]][k.split('@')[1]]['buffs'] = skill_buff[1]  # assigns skill buff data
    when 'skills_ignited'
      if new_unit['skills_ignited'] == []
        new_unit['skills_ignited'] = add_empty_ignited_skill(true)
      end
      skill_buff = grab_buff_details(new_unit[ k.split('@')[0]][k.split('@')[1]]['buffs'], v)  # gets buff data from new skills
      new_unit[ k.split('@')[0]][k.split('@')[1]]['text'] = skill_buff[0] # assigns skill names
      new_unit[ k.split('@')[0]][k.split('@')[1]]['buffs'] = skill_buff[1] # assigns skill buff data
    end
  end

  # reorders the keys
  sort_order = [:idx, :name, :attribute, :role, :grade, :status, :skins, :skills, :skills_ignited]
  new_unit = new_unit.sort_by { |k, _| sort_order.index(k.to_sym) }.to_h

  # adds unit to db file or replaces existing entry
  if params['new_unit'] == 'true'
    main_db << new_unit
  elsif params['edited_unit'] == 'on'
    main_db[idx_of_arr_data] = new_unit
  end

  if params['edited_unit'] == 'on'
    session[:message] = " -- Profile Updated: #{name.upcase}"
    add_to_history(" -- Profile Updated: #{idx} -- #{name.upcase}.", 'history')
  else
    session[:message] = " -- Profile Created: #{name.upcase}"
    add_to_history(" -- Profile Created: #{idx} -- #{name.upcase}.", 'history')
  end
  puts "-- Updated Unit '#{name.upcase}' Profile! --"

  # writes the data to file
  if REGION == "JAPAN"
    File.open('data/childs/CharacterDatabaseJp.json', 'w') { |file| file.write(main_db.to_json) }
  else
    File.open('data/childs/CharacterDatabaseEn.json', 'w') { |file| file.write(main_db.to_json) }
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
  it_is_new = true if original_name.empty?

 ##############
  name = ''
  if original_name.empty?
    name = params[:sc_name]
  elsif !original_name.empty? && params[:sc_name].empty?
    name = original_name
  else
    name = params[:sc_name].gsub("'", "\'").downcase
  end
    sc_id = params['dbcode'].to_i

  ############

  sc_ref_list = ''
  yml_path = ''
  json_file_path = ''
  image = ''

  sc_ref_list = fetch_json_data('soulcardref')
  sc_db = fetch_json_data('soulcarddb')

  locale = REGION == 'JAPAN' ? 'jp' : 'en'
    sc_ref_path = "data/sc/soulcardRefList#{locale.capitalize}.json"
    sc_db_path = "data/sc/SoulCartas#{locale.capitalize}.json"
    image = create_file_from_upload(params[:file], params[:pic], 'public/images/sc') unless (params[:edited] == 'on')

  idx = params['idx']
  sc_id = params['dbcode'].to_i
  isprism = params['grade'].to_i == 5
  created_on = params['date'].nil? ? "" : params['date']
  new_time = Time.now.utc.localtime('+09:00')
  created_on = new_time.to_date.to_s if created_on.empty?

  if params[:edited] == 'on'
    if params[:edited_db] == 'on'
      edit_sc_db(params, name, sc_ref_list, sc_ref_path, sc_db_path, sc_db)
    else
      # This edits the REF FILE only and returns. It does not edit data files
      edit_sc_reflist(params, name, sc_ref_list, sc_ref_path, sc_db_path, sc_db)
    end
    session[:message] = " -- Soulcard Updated: #{name.upcase}"
    add_to_history(" -- Soulcard Ref Updated: #{idx} -- #{name.upcase}.", 'history')

    redirect '/sc_edit_list'
  end

  new_sc_temp = new_sc_data_template
  new_sc_temp_prism = new_sc_data_template(isprism) if isprism

  idx, new_sc_temp = assign_sc_data_to_template(new_sc_temp, params, name)
  idx2, new_sc_temp_prism = assign_sc_data_to_template(new_sc_temp_prism, params, name, isprism) if isprism

  # adds new ref data template
  ref_data = add_to_sc_reflist(params, idx, idx2, isprism, it_is_new, name, created_on, image)

  sc_ref_list << ref_data
  sc_db[idx] = new_sc_temp
  sc_db[idx2] = new_sc_temp_prism unless (idx2.nil? && new_sc_temp_prism.nil?)

  File.open(sc_ref_path, 'w') { |file| file.write(sc_ref_list.to_json) }
  File.open(sc_db_path, 'w') { |file| file.write(sc_db.to_json) }

  session[:message] = " -- Soulcard Created: #{name.upcase}"
  add_to_history(" -- Soulcard Profile Created: #{idx} -- #{name.upcase}.", 'history')

  puts "-- Updated SoulCard Profile! --"
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

  directory =
  if ['history_log.yml', 'search_log.yml'].include?(name)
    'data/'
  # elsif name.include?('soul_cards')
  #   'data/'
  elsif name.include?('.css')
    'public/stylesheets/'
  elsif name.include?('full')
    'public/images/full/'
  elsif name.include?('.png')
    'public/images/portraits/' if params['full_image'] == '1'
    # 'public/portraits/' if params['full_image'] == '1'
  elsif name.include?('.jpg') || params['soulcard_image'] == '1'
    if name.include?('pc0')
      'public/images/sc/'
    else
      REGION == 'JAPAN' ? 'public/images/sc/jp/' : 'public/images/sc/gl/'
    end
  elsif name.include?('.gif')
    'public/images/stats/'
  else
    session[:message] = 'Not a valid file-type'
    redirect '/upload_file'
  end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  session[:message] = 'file uploaded!'
  add_to_history("File uploaded: #{name}", 'history')


  redirect '/upload_file'
end
