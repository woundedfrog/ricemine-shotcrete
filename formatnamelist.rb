
module FormatNameList

  # def quick_ref_list_build_from_yaml_and_other_files(character, name)
  #   # unused
  #   # this is a shortcut way to update and dump data from the YML file like dates and such
  #   yamlf = File.expand_path('data/unit_details.yml', __dir__)
  #   yaml_data = YAML.load_file(yamlf)
  #   x =   [idx = character['idx'],
  #   code = (character['skins'].keys[0][0..4] + '01'),
  #   en_name = name,
  #   jp_name = character['skins'].values[0],
  #   kr_name = character['name'],
  #   img1 = yaml_data[name]['pic'],
  #   img2 = yaml_data[name]['pic2'],
  #   img3 = yaml_data[name]['pic3'],
  #   date = yaml_data[name]['date']]
  #
  #   save_eng_name_and_idx_to_file(x)
  # end

  # def grab_data_from_olddb(idx_code, jp_db, en_db)
  #   return if idx_code.nil?
  #
  #   unit = en_db[idx_code]
  #   kor_n = unit['kname'].split(" ")[-1]
  #   jp_db_idx = jp_db.find_index {|k,_| k['name'].downcase.include?(kor_n.downcase) || kor_n.downcase.include?(k['name'].downcase) }
  #   jp_unit = jp_db[jp_db_idx]
  #   char_code = jp_unit['skins'].keys[0][0..4] + '01'
  #
  #   [
  #     jp_unit['idx'],
  #     char_code,
  #     unit['name'].downcase,
  #     jp_unit['skins'][char_code],
  #     jp_unit['name'],
  #     "img?",
  #     "img?",
  #     "img?"]
  #   end

    def add_names_json_ref_list(name_param, code_param)
      # this method checks Two json files and combines the matched details
      # it calls a second method and dumps the data in a reference json file.
      if !code_param.nil?
        code_param = code_param + "_01" if !code_param.include?("_01") && code_param.size < 6
        code_param = ('c' + code_param) if !code_param.include?('c') && !code_param.include?('m')
      end
      jp_db = fetch_json_data('maindb')
      en_db = JSON.parse(File.read('data/oldjpbaridb.json'))
      new_data = []

      if !code_param.nil?
        idx_of_code = jp_db.find_index {|k,_| next if filter_skin_class(k); (k['skins'].keys[0][0..4] + '01') == code_param}
        data = jp_db[idx_of_code]

        new_data = [idx = data['idx'],
        code = code_param,
        en_name = name_param,
        jp_name = data['skins'][code_param],
        kr_name = data['name'],
        img1 = code_param[0..-2] + "0",
        img2 = code_param,
        img3 = code_param[0..-2] + "2"]
      else
        return
        # fallback_code = en_db.find_index {|k,_| k['name'].downcase.include?(name_param.downcase)}
        #
        # new_data = grab_data_from_olddb(fallback_code, jp_db, en_db)
      end


      new_unit = new_data
      return if new_unit.nil?
      # calls method to save/dump new details

      save_eng_name_and_idx_to_file(new_unit)

      name_param
    end

    def save_eng_name_and_idx_to_file(data)
      # not used anymore
      name_file = fetch_json_data('reflistdb')
      yamlf = File.expand_path('data/unit_details.yml', __dir__)
      yaml_data = YAML.load_file(yamlf)

      exists = false
      name_file.each do |k|
        exists = true if k['idx']== data[0]
        break if exists
      end

      if exists
        # if data exists in ref list, then it's updated
        name_file = name_file.map do |unit|
          if unit["idx"] == data[0]
            unit.each_with_index do |(key, value), idx|
              unit[key] = data[idx]
              unit[key] = value if data[idx].nil?
            end
            unit['tiers'] = yaml_data[data[2]]['tier']
            unit['notes'] = yaml_data[data[2]]['notes']
            unit['date'] = yaml_data[data[2]]['date']
          else
            unit
          end
        end
      else
        # if data doesn't exists in ref list, then it's added
        x = {
          "idx"=> data[0],
          "code"=> data[1],
          "en_name"=> data[2],
          "jp_name"=> data[3],
          "kr_name"=> data[4],
          "image1"=> yaml_data[data[2]]['pic'],
          "image2"=> yaml_data[data[2]]['pic2'],
          "image3"=> yaml_data[data[2]]['pic3'],
          "tiers"=> yaml_data[data[2]]['tier'],
          "notes"=> yaml_data[data[2]]['notes'],
          "date"=>
          if yaml_data[data[2]]['date'].nil?
            new_time = Time.now.utc.localtime('+09:00')
            [new_time.year, new_time.month, new_time.day].join('-')
          end
        }

        name_file << x
      end

      if REGION == "JAPAN"
        File.open('data/childs/characterRefListJp.json', 'w') { |file| file.write(name_file.to_json) }
      else
        File.open('data/childs/characterRefListEn.json', 'w') { |file| file.write(name_file.to_json) }
      end
    end
    # finding data to the untis.


    #this grabs the ENGLISH names from the ENG db json and adds it to the name_list_ref
    def get_eng_name_from_global_db
      #not used anymore, i think
      #call from any method / route
      eng_db = JSON.parse(File.read('data/CharacterDatabaseEn.json'))
      jp_db = JSON.parse(File.read('data/CharacterDatabaseJp.json'))
      ref_list = fetch_json_data('reflistdb')
      x = {}
      updated_ref_list = ''
      updated = []
      jp_db.each do |jpunit|
        en_db_idx = eng_db.find_index {|k,_| jpunit['idx'] == k['idx'] }
        next if en_db_idx.nil? || jpunit['grade'] < 3
        new_en_u = eng_db[en_db_idx]

        if ref_list.any? { |refunit| jpunit['idx'] ==  refunit['idx'] && refunit['idx'] == new_en_u['idx'] }

          updated_ref_list = ref_list.map do |refunit|
            if refunit['idx'] == new_en_u['idx']

              refunit['en_name'] = new_en_u['skins'][refunit['code']]
              refunit
            else
              refunit
            end
          end

          updated_ref_list.each do |unit|
          end
        else

          code = new_en_u['skins'].keys[0]
          char_code = if code.include?("c")
            (new_en_u['skins'].keys[0][0..-3] + "01")
          else
            code
          end

          x = {
            "idx"=> new_en_u['idx'],
            "code"=> char_code,
            "en_name"=> new_en_u['skins'][char_code],
            "jp_name"=> jpunit['skins'][char_code],
            "kr_name"=> new_en_u['name'],
            "image1"=> char_code,
            "image2"=> "",
            "image3"=> "",
            "tiers"=> "",
            "notes"=> "",
            "date"=> "2020-1-01"
          }
          updated_ref_list << x
          updated << [x['idx'], x['en_name']]
        end

      end

      if REGION == "JAPAN"
        File.open('data/childs/characterRefListJp.json', 'w') { |file| file.write(updated_ref_list.to_json) }
      else
        File.open('data/childs/characterRefListEn.json', 'w') { |file| file.write(updated_ref_list.to_json) }
      end
    end
    #######################

    #dump data from sc.yaml to json
    # def dump_sc_data_to_ref_list(region = 'jp')
    #   # unused
    #
    #   sc_ref_list = ''
    #   yamlf = ''
    #
    #   if region == 'en'
    #     sc_ref_list = JSON.parse(File.read('data/sc/soulcardDatabaseEn.json'))
    #     yamlf = File.expand_path('data/sc/soul_cardsEn.yml', __dir__)
    #   elsif region == 'jp'
    #     sc_ref_list = JSON.parse(File.read('data/sc/soulcardDatabaseJp.json'))
    #     yamlf = File.expand_path('data/sc/soul_cardsJp.yml', __dir__)
    #   end
    #
    #   yaml_data = YAML.load_file(yamlf)
    #   sc_names = yaml_data.keys
    #   sc = []
    #   new_time = Time.now.utc.localtime('+09:00')
    #   dd = [new_time.year, new_time.month, new_time.day].join('-')
    #
    #   yaml_data.each do |key,val|
    #     # this will OVERWRITE, not UPDATE !!!NOTE!!!
    #     dump = {
    #       "idx": "",
    #       "dbcode": val['index'],
    #       "grade": val['stars'].to_i,
    #       "code": "",
    #       "en_name": key,
    #       "jp_name": "",
    #       "kr_name": "",
    #       "image1": val['pic'],
    #       "notes": "",
    #       "date": "2020-07-10"
    #     }
    #     sc << dump
    #   end
    #   if region == 'en'
    #     File.open('data/soulcardDatabaseEn.json', 'w') { |file| file.write(sc.to_json) }
    #   else
    #     File.open('data/soulcardDatabaseJp.json', 'w') { |file| file.write(sc.to_json) }
    #   end
    # end

    def create_file_from_upload(uploaded_file, pic_param, directory)
      #creates images and uploads it to server files
      if !uploaded_file.nil?
        (tmpfile = uploaded_file[:tempfile].gsub(/[\s\'_]/, "")) && (pname = uploaded_file[:filename].gsub(/[\s\'_]/, ""))
        path = File.join(directory, pname)
        File.open(path, 'wb') { |f| f.write(tmpfile.read) }
      elsif params[:pic].empty?
        pname = 'emptyunit0.png'
      else
        pname = pic_param
      end

      directory.gsub!('public', '')
      pname.include?(directory) ? pname : "#{directory}/" + pname
    end

    ### temp methods
    def sc_data_from_yml(name)
      yamlf = ''
      if  REGION == 'GLOBAL'
        sc_ref_list = fetch_json_data('soulcarddb')
        yamlf = File.expand_path('data/sc/soul_cardsEn.yml', __dir__)
      else
        sc_ref_list = fetch_json_data('soulcarddb')
        yamlf = File.expand_path('data/sc/soul_cardsJp.yml', __dir__)
      end
      sc_idx = sc_ref_list.find_index {|k,_| k['en_name'].downcase == name.downcase }

      yaml_data = YAML.load_file(yamlf)
      x = yaml_data[name]
      x['name'] = name
      x['notes'] = sc_ref_list[sc_idx]['notes']
      x['date']= sc_ref_list[sc_idx]['date']
      x

    end
    ## grabs data by stars for SORTBY page
    def sort_grab_by_stars(stars, show_all = false)

      main_db_dump = fetch_json_data('maindb')
      name_ref_list = fetch_json_data('reflistdb')

      selected_info = []

      name_ref_list.each do |unit|
        next if exclusion_list(unit) || (unit['enabled'] == 'f' if show_all != 'show_all')
        idx_num = unit['idx']
        data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
        next if (data_dump_idx.nil? || main_db_dump[data_dump_idx]['grade'] < 3)

        selected_info << sort_assign_data(main_db_dump[data_dump_idx], unit, unit['en_name'], false) # false to say it isn't for profile
      end

      selected_info = selected_info.flatten.sort_by {|k| [Date.parse(k['date']).to_s, k['en_name']]}.reverse if stars == 'all'

      if stars != 'all'
        x = selected_info.flatten.select do |k|
          k['stars'].to_s == stars
        end
        selected_info = x
      end
      selected_info.flatten
    end

    def find_missing_units_not_in_ref_list(stars)
      # use this to seach for missing units not in ref list
      main_db_dump = fetch_json_data('maindb')
      name_ref_list = fetch_json_data('reflistdb')

      selected_info = []
      #jp version
      mains = fetch_json_data('maindb').select {|k| next if filter_skin_class(k); k['skins'].keys.any?{|c| c.include?('c')}}
      #en version
      # mains = JSON.parse(File.read('data/CharacterDatabaseEn.json')).select {|k| k['skins'].keys.any?{|c| c.include?('c')}}

      reflis = fetch_json_data('reflistdb')
      found = []
      notfound = []
      mains.each do |unit|
        if  reflis.any? { |kk| kk['idx'] == unit['idx']}
          found << [unit['idx'], unit['skins'].keys[0]] unless found.include?([unit['idx'], unit['skins'].keys[0]] )
        else
          notfound << [unit['idx'], unit['skins'].keys[0], unit['skins'].values[0]] unless notfound.include?([unit['idx'], unit['skins'].keys[0], unit['skins'].values[0]] )
        end
      end

      notfound.each do |arr|
        data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == arr[0] }

        selected_info << sort_assign_data(main_db_dump[data_dump_idx], arr, arr[2], false)
      end

      if stars != 'all'
        x = selected_info.flatten.select do |k|
          k['stars'].to_s == stars
        end
        selected_info = x
      end
      selected_info.flatten
    end

    def add_missing_units_names
      missing = find_missing_units_not_in_ref_list('all')
      reflist = fetch_json_data('reflistdb')
      maindb = fetch_json_data('maindb')
      selected = []

      missing.each do |arr|
        # maindb.each do |unit_prof|
        #
        #     binding.pry
        #   p [unit_prof['idx'],arr['char_idx'],unit_prof['idx'] == arr[0]]
        #   if unit_prof['idx'] == arr[0]
        #     code = unit_prof['skins'].keys[0]
        #     if code.include?('m')
        #       code
        #     else
        #       code = code[0..-3] + '01'
        #     end
        x = {
          "idx"=> arr['char_idx'],
          "code"=> arr['char_code'],
          "en_name"=> arr['en_name'],
          "jp_name"=> arr['jp_name'],
          "kr_name"=> arr['kr_name'],
          "image1"=> arr['pics'],
          "image2"=> "",
          "image3"=> "",
          "tiers"=> "",
          "notes"=> "",
          "date"=> "2020-09-01"
        }
        #   end
        #   selected << x
        # end
        reflist << x unless reflist.include?(x)
      end
      if REGION == "JAPAN"
        File.open('data/childs/characterRefListJp.json', 'w') { |file| file.write(reflist.to_json) }
      else
        File.open('data/childs/characterRefListEn.json', 'w') { |file| file.write(reflist.to_json) }
      end
    end

    # this is for searching
    def check_stats_for_keywords(main_db, key_words, idx_num, en_name)
      matched_from_data = []
      main_db.each do |unit|

        next if exclusion_list(unit)
        if unit['idx'] == idx_num
          x = {}
          if (unit['skills']['normal']['text'] + unit['skills']['slide']['text'] + unit['skills']['drive']['text']).downcase.include?(key_words)

            next if key_words == 'target' &&
            !(unit['skills']['normal']['text'] + unit['skills']['slide']['text'] + unit['skills']['drive']['text']).downcase.include?('chance for <color=ffffff>target')
            x['idx'] = unit['idx']
            x['en_name'] = en_name
          end
        end
        matched_from_data << x if x != {}
      end
      matched_from_data
    end

    def search_data_for_keywords(main_db_dump, name_ref_list, words)

      matched_names = []
      matched_data = []
      name_ref_list.each do |unit|
        next if exclusion_list(unit)
        x = {}
        if (unit['en_name'].downcase.include?(words.downcase) || unit['notes'].downcase.include?(words.downcase))
          x['idx'] = unit['idx']
          x['en_name'] = unit['en_name']
        end
        matched_names << x if x != {}
        matched_data << check_stats_for_keywords(main_db_dump,words, unit['idx'], unit['en_name'])
      end

      [matched_names, matched_data.flatten.uniq]

    end

    private

def remove_unit(name)
  db = fetch_json_data('maindb')
  reflist = fetch_json_data('reflistdb')

  idx_num = ''
  reflist.each {|unit| idx_num = unit['idx'] if unit['en_name'].downcase == name.downcase }

  ref_location = reflist.find_index {|k| k['idx'] == idx_num || k['en_name'].downcase == name.downcase }
  db_location = db.find_index {|k,_| k['idx'] == idx_num }

  if ref_location.nil? || db_location.nil?
    session[:message] = "Could not locate and remove that Unit!"
    redirect '/unit_edit_list'
  end

  db.delete_at(db_location) if db[db_location]['idx'] == idx_num
  reflist.delete_at(ref_location) if reflist[ref_location]['idx'] == idx_num

  if REGION == "JAPAN"
    File.open('data/childs/CharacterDatabaseJp.json', 'w') { |file| file.write(db.to_json) }
      File.open('data/childs/characterRefListJp.json', 'w') { |file| file.write(reflist.to_json) }
  else
    File.open('data/childs/CharacterDatabaseEn.json', 'w') { |file| file.write(db.to_json) }
      File.open('data/childs/characterRefListEn.json', 'w') { |file| file.write(reflist.to_json) }
  end
end

def filter_skin_class(data)
  right_class = ''
  begin
    right_class = data['skins'] == []
  rescue
    right_class = false
  end
  right_class
end

def exclusion_list(unit)
  excluding_list = ["10100020","10100140","10200102","20100079","20100080","20100081","20100082",
    "20100083","20100084","20100085","20100086","20100087","20100088","20100096",
    "20100097","20100137","20100141","20100142","20100143","20100144","20100145",
    "20100146","20100147","20100148","20100157","10100001","10200192","10200195",
    "10200203","10200243","10200244","20100135","20100150","20100151","20100152",
    "20100153","20100154","20100155","20100158"]
    excluding_list.include?(unit['idx'])
  end
end

def directory_exists?(file)
  File.file?(file)
end

def assign_profile_data(character, reference_list, ignited)
  char_hash = {}
  mainstats = {}
  substats = {}
  buffs = {}
  skill_detail = {}
  pics = {}

  skills = if ignited && !character['skills_ignited'].empty?
            character['skills_ignited']
          else
            character['skills']
          end

  found = character['skins'].keys.any? {|cc| cc[-3..-1] == "_02" }
  code =  if found
          character['skins'].keys[0].include?("m") ? character['skins'].keys[0] : (character['skins'].keys[0][0..4] + '02')
        else
          character['skins'].keys[0].include?("m") ? character['skins'].keys[0] : (character['skins'].keys[0][0..4] + '01')
        end

  char_hash['char_code'] = code
  char_hash['char_idx'] = character['idx']
  char_hash['char_kr_name'] = character['name']
  char_hash['char_jp_name'] = character['skins'].values[0]
  char_hash['char_jp_skin'] = character['skins'].values[0] # wasted
  char_hash['char_jp_skin_name'] = character['skins'].values[0] # wasted
  mainstats['stars'] = character['grade']
  mainstats['role'] = character['role']
  mainstats['attribute'] = character['attribute']
  mainstats['tier'] = reference_list['tiers'].empty? ? '0 0 0 0' : reference_list['tiers']
  mainstats['tier'] = reference_list['tiers2'].empty? ? '0 0 0 0' : reference_list['tiers2'] if ignited
  # mainstats['tier'] = reference_list['tiers'] if (ignited && reference_list['tiers2'] == '0 0 0 0')
  substats['auto'] = skills['default']['text']
  substats['tap'] = skills['normal']['text']
  substats['slide'] = skills['slide']['text']
  substats['drive'] = skills['drive']['text']
  substats['leader'] = skills['leader']['text']
  substats['notes'] = reference_list['notes']
  substats['date'] = reference_list['date']
  buffs['tap_buffs_path'] = get_buff_icon_text_info(skills['normal']['buffs'], true)
  buffs['slide_buffs_path'] = get_buff_icon_text_info(skills['slide']['buffs'], true)
  buffs['drive_buffs_path'] = get_buff_icon_text_info(skills['drive']['buffs'], true)
  buffs['leader_buffs_path'] = get_buff_icon_text_info(skills['leader']['buffs'], true)
  skill_detail['tap_skill_detail'] = get_buff_icon_text_info(skills['normal']['buffs'])
  skill_detail['slide_skill_detail'] = get_buff_icon_text_info(skills['slide']['buffs'])
  skill_detail['drive_skill_detail'] = get_buff_icon_text_info(skills['drive']['buffs'])
  skill_detail['leader_skill_detail'] = get_buff_icon_text_info(skills['leader']['buffs'])

  character['skins'].size.times do |num|
    img = character['skins'].keys.sort
    pics['pics'] = img[0] if num == 0
    pics["pics#{num}"] = img[num] unless (num == 0 || img[num][-2..-1] == '88' || img[num][-2..-1] == '82' || img[num][-2..-1] == '89')
    # pics['pics'] = character['skins'].keys[0] if num == 0
    # pics["pics#{num}"] = character['skins'].keys[num] if num != 0
  end
  [char_hash, mainstats, substats, buffs, skill_detail, pics, character['skills_ignited'].empty?]
end

def assign_search_data(character, name)
  char_hash = {}

  char_hash['char_code'] = (character['skins'].keys[0][0..4] + '01')
  char_hash['char_idx'] = character['idx']
  char_hash['en_name'] = name
  char_hash['role'] = character['role']
  char_hash['attribute'] = character['attribute']
  char_hash
end

def assign_index_data(character, reference_list, name)
  char_hash = {}

  found = character['skins'].keys.any? {|cc| cc[-3..-1] == "_02" }

  code = if found
          character['skins'].keys[0].include?("m") ? character['skins'].keys[0] : (character['skins'].keys[0][0..4] + '02')
        else
          character['skins'].keys[0].include?("m") ? character['skins'].keys[0] : (character['skins'].keys[0][0..4] + '01')
        end
  char_hash['char_code'] = code
  char_hash['char_idx'] = character['idx']
  char_hash['en_name'] = name
  char_hash['kr_name'] = character['name']
  char_hash['jp_name'] = character['skins'].values[0]
  char_hash['role'] = character['role']
  char_hash['attribute'] = character['attribute']
  char_hash['pics'] = code
  char_hash['stars'] = character['grade']
  char_hash['date'] = (reference_list.class == Array || reference_list['date'] == '') ? '2020-10-10' : reference_list['date']
  char_hash['tiers'] = (reference_list.class == Array || reference_list['tiers'] == '') ? '0 0 0 0' : reference_list['tiers']
  char_hash['tiers2'] = (reference_list.class == Array || reference_list['tiers2'] == '') ? '0 0 0 0' : reference_list['tiers2']
  char_hash['enabled'] = reference_list['enabled'] unless reference_list.class == Array
  [char_hash]
end

############# NEW UNIT DATA METHODS #############


def get_skill_text_only(skills)
  # filters out and grabs skill text from skill data
  x = {}
  skills.each do |skill_type, skill_inf|
    x[skill_type] = skill_inf['text']
  end
  x
end

def add_empty_ignited_skill(for_edit = false)
  x = {
    "default":"",
    "normal":"",
    "slide":"",
    "drive":"",
    "leader":""
  }
  y = {
    "default":{
      "idx":"11010401",
      "name":"NA",
      "text":"",
      "buffs":{}
    },
    "normal":{
      "idx":"25140010",
      "name":"NA",
      "text":"",
      "buffs":{}
    },
    "slide":{
      "idx":"35140010",
      "name":"NA",
      "text":"",
      "buffs":{}
    },
    "drive":{
      "idx":"45140010",
      "name":"NA",
      "text":"",
      "buffs":{}
    },
    "leader":{
      "idx":"55140020",
      "name":"NA",
      "text":"",
      "buffs":{}
    }
  }
   for_edit ? JSON.parse(y.to_json) : JSON.parse(x.to_json)
end

def dump_buff_details_to_file
  # grabs all the buffs from the game.

  region = REGION == "JAPAN" ? 'Jp' : 'En'
  type = 'ch'

  db = JSON.parse(File.read("./data/childs/CharacterDatabase#{region.capitalize}.json"))

  buffs_ids = []
  buffs = []

  db.each do |unit|
    next if  unit['skills']['default']['idx'] == '0'
    unit['skills'].each do |skill, sinfo|

      sinfo['buffs'].each do |bname, binfo|
        unless buffs_ids.include?(binfo['idx'])
          buffs_ids << binfo['idx']
          buffs << binfo
        end
      end
    end
  end
  buffs = buffs.sort_by {|a| a['idx']}

  File.open("./data/childs/BuffsInfo#{region.capitalize}.json", 'w') { |file| file.write(buffs.to_json) }
end

def grab_buff_details(new_unit, skill_text)
  # hide this for now. this adds and edits buffs for units
  region = REGION == "JAPAN" ? 'Jp' : 'En'
  buffdb = JSON.parse(File.read("./data/childs/BuffsInfo#{region.capitalize}.json"))

  found_buff =
  new_unit.select do |_,val|
    #finds and selects found buffs in the new skills
    skill_text.downcase.include?(">#{val['name'].downcase}<") || skill_text.downcase.include?(">#{val['idx'].downcase}<")
  end
  if found_buff == []
    counter = 1
   else
     counter = (found_buff.keys.max).to_i
   end
  counter.nil? ? 1 : counter += 1
  buffdb.each do |buff|
      # scans the skill text for buff idxs and then replaces it with the name and adds the buff data
      if skill_text.downcase.include?(buff['idx'].downcase)
          found_buff[counter.to_s] = buff unless found_buff.values.include?(buff)
          skill_text = skill_text.gsub(">#{buff['idx']}<", ">#{buff['name']}<")
          counter += 1
      end
  end

  final_buffs = {}
  counter = 1
  found_buff.each_with_index do |(k,v),index|
    # selects only new and existing buffs to keep, and fixes the key index nums
     if skill_text.downcase.include?(">#{v['name'].downcase}<")
       final_buffs[counter] = v
       counter += 1
     end
  end
  [skill_text, final_buffs]
end

def new_unit_data_template
  template = {
    "idx":"",
    "name":"",
    "attribute":"",
    "role":"",
    "grade":0,
    "status":{
      "hp":0,
      "def":0,
      "atk":0,
      "cri":0,
      "agi":0
    },
    "skins":{
    },
    "skills":{
      "default":{
        "idx":"11010401",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "normal":{
        "idx":"25140010",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "slide":{
        "idx":"35140010",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "drive":{
        "idx":"45140010",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "leader":{
        "idx":"55140020",
        "name":"NA",
        "text":"",
        "buffs":{}
      }
    },
    "skills_ignited":{
      "default":{
        "idx":"11010401",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "normal":{
        "idx":"25140010",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "slide":{
        "idx":"35140010",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "drive":{
        "idx":"45140010",
        "name":"NA",
        "text":"",
        "buffs":{}
      },
      "leader":{
        "idx":"55140020",
        "name":"NA",
        "text":"",
        "buffs":{}
      }
    }
}
end
