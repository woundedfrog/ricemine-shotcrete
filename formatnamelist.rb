

module FormatNameList

  def quick_ref_list_build_from_yaml_and_other_files(character, name)
    # this is a shortcut way to update and dump data from the YML file like dates and such
    yamlf = File.expand_path('data/unit_details.yml', __dir__)
    yaml_data = YAML.load_file(yamlf)
    x =   [idx = character['idx'],
            code = (character['skins'].keys[0][0..4] + '01'),
            en_name = name,
            jp_name = character['skins'].values[0],
            kr_name = character['name'],
            img1 = yaml_data[name]['pic'],
            img2 = yaml_data[name]['pic2'],
            img3 = yaml_data[name]['pic3'],
            date = yaml_data[name]['date']]

    save_eng_name_and_idx_to_file(x)
  end

  def grab_data_from_olddb(idx_code, jp_db, en_db)
    return if idx_code.nil?

    unit = en_db[idx_code]
    kor_n = unit['kname'].split(" ")[-1]
    jp_db_idx = jp_db.find_index {|k,_| k['name'].downcase.include?(kor_n.downcase) || kor_n.downcase.include?(k['name'].downcase) }
    jp_unit = jp_db[jp_db_idx]
    char_code = jp_unit['skins'].keys[0][0..4] + '01'

    [
       jp_unit['idx'],
       char_code,
       unit['name'].downcase,
      jp_unit['skins'][char_code],
       jp_unit['name'],
      "img?",
      "img?",
       "img?"]
  end

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
      idx_of_code = jp_db.find_index {|k,_| next if k['skins'] == [];(k['skins'].keys[0][0..4] + '01') == code_param}
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

      File.open('data/character_idx_name.json', 'w') { |file| file.write(name_file.to_json) }
  end
  # finding data to the untis.

  def format_new_sc_stats(stats, passive_skill = false)
    #this formates the NEW SC stats to fit the old style of yaml file
    stats.gsub!(':', '')
    arr = []
    if !passive_skill
      stats.split(' ').each_with_index do |part, idx|
        if idx < 4
          arr << part
        end
      end
    else
      key = ''
      arr = [[],[]]
      stats.split(' ').each_with_index do |word, idx|
        if ['restriction', 'restrictions'].include?(word.downcase)
          key = 'Restriction'
          word = key
        elsif ['ability', 'abilities'].include?(word.downcase)
          key = 'Ability'
          word = key
        end
        if key == 'Restriction'
          arr[0] << word
        else
          arr[1] << word
        end
      end
      arr[0] = [arr[0][0], arr[0][1..-1].join(' ')]
      arr[1] = [arr[1][0], arr[1][1..-1].join(' ')]
      arr
    end
    arr
  end

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
    File.open('data/character_idx_name.json', 'w') { |file| file.write(updated_ref_list.to_json) }

  end
  #######################

  #dump data from sc.yaml to json
  def dump_sc_data_to_ref_list(region = 'jp')
    sc_ref_list = ''
    yamlf = ''

    if region == 'gl'
      sc_ref_list = JSON.parse(File.read('data/sc/gl/soulcardDatabaseGl.json'))
      yamlf = File.expand_path('data/sc/gl/soul_cards.yml', __dir__)
    elsif region == 'jp'
      sc_ref_list = JSON.parse(File.read('data/sc/jp/soulcardDatabaseJp.json'))
      yamlf = File.expand_path('data/sc/jp/soul_cards.yml', __dir__)
    end

    yaml_data = YAML.load_file(yamlf)
    sc_names = yaml_data.keys
    sc = []
    new_time = Time.now.utc.localtime('+09:00')
    dd = [new_time.year, new_time.month, new_time.day].join('-')

    yaml_data.each do |key,val|
      # this will OVERWRITE, not UPDATE !!!NOTE!!!
      dump = {
          "idx": "",
          "dbcode": val['index'],
          "grade": val['stars'].to_i,
          "code": "",
          "en_name": key,
          "jp_name": "",
          "kr_name": "",
          "image1": val['pic'],
          "notes": "",
          "date": "2020-07-10"
        }
      sc << dump
    end
    if region == 'gl'
      File.open('data/soulcardDatabaseGl.json', 'w') { |file| file.write(sc.to_json) }
    else
      File.open('data/soulcardDatabaseJp.json', 'w') { |file| file.write(sc.to_json) }
    end
  end

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
      yamlf = File.expand_path('data/sc/gl/soul_cards.yml', __dir__)
    else
      sc_ref_list = fetch_json_data('soulcarddb')
      yamlf = File.expand_path('data/sc/jp/soul_cards.yml', __dir__)
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
  def sort_grab_by_stars(stars)

    main_db_dump = fetch_json_data('maindb')
    name_ref_list = fetch_json_data('reflistdb')

    selected_info = []
    name_ref_list.each do |unit|
    idx_num = unit['idx']
      data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
      next if data_dump_idx.nil?
      selected_info << sort_assign_data(main_db_dump[data_dump_idx], unit, unit['en_name'], false) # false to say it isn't for profile
    end

    selected_info = selected_info.flatten.sort_by {|k| [k['date'],k['en_name']]}.reverse if stars == 'all'

    if stars != 'all'
      x = selected_info.flatten.select do |k|
        k['stars'].to_s == stars
      end
      selected_info = x
    end
    selected_info.flatten
  end

  def find_missing_units_not_in_ref_list(stars)

        main_db_dump = fetch_json_data('maindb')
        name_ref_list = fetch_json_data('reflistdb')

                selected_info = []
                #jp version
                mains = JSON.parse(File.read('data/CharacterDatabaseJp.json')).select {|k| k['skins'].keys.any?{|c| c.include?('c')}}
                #en version
                # mains = JSON.parse(File.read('data/CharacterDatabaseEn.json')).select {|k| k['skins'].keys.any?{|c| c.include?('c')}}

                reflis = JSON.parse(File.read('data/character_idx_name.json'))
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
  File.open('data/character_idx_name.json', 'w') { |file| file.write(reflist.to_json) }

  end

# this is for searching
  def check_stats_for_keywords(main_db, key_words, idx_num, en_name)
    matched_from_data = []
    main_db.each do |unit|
      if unit['idx'] == idx_num
        x = {}
        if (unit['skills']['normal']['text'] + unit['skills']['slide']['text'] + unit['skills']['drive']['text']).downcase.include?(key_words)
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


end
