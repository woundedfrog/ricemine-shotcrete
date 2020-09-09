

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
    jp_db = fetch_json_data('mainjp')
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

  #this grabs the ENGLISH names from the ENG db json and adds it to the name_list_ref
  def get_eng_name_from_global_db
    #call from any method / route
    eng_db = fetch_json_data('mainen')
    jp_db = fetch_json_data('mainjp')
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
  def dump_sc_data_to_ref_list
    sc_ref_list = fetch_json_data('soulcarddb')
    yamlf = File.expand_path('data/soul_cards.yml', __dir__)
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
          "date": "2020-8-1"
        }
      sc << dump
    end
    File.open('data/soulcardDatabaseJp.json', 'w') { |file| file.write(sc.to_json) }
  end

  ### temp methods
  def sc_data_from_yml(name)
    sc_ref_list = fetch_json_data('soulcarddb')
    sc_idx = sc_ref_list.find_index {|k,_| k['en_name'].downcase == name.downcase }

    yamlf = File.expand_path('data/soul_cards.yml', __dir__)
    yaml_data = YAML.load_file(yamlf)
    x = yaml_data[name]
    x['name'] = name
    x['notes'] = sc_ref_list[sc_idx]['notes']
    x['date']= sc_ref_list[sc_idx]['date']
    x

  end
## grabs data by stars for SORTBY page
  def sort_grab_by_stars(stars)
    main_db_dump = fetch_json_data('mainjp')
    name_ref_list = fetch_json_data('reflistdb')

    selected_info = []
    name_ref_list.each do |unit|
    idx_num = unit['idx']
      data_dump_idx = main_db_dump.find_index {|k,_| k['idx'] == idx_num }
      selected_info << sort_assign_data(main_db_dump[data_dump_idx], unit, nil, unit['en_name'], false) # false to say it isn't for profile
    end

    if stars != 'all'
      selected_info = selected_info.flatten.select do |k|
        k['stars'].to_s == stars
      end
    end
    selected_info
  end

# this is for searching
  def check_stats_for_keywords(main_db, key_words, en_name)
    matched_from_data = []
    main_db.each do |unit|
      x = {}
      if (unit['skills']['normal']['text'] + unit['skills']['slide']['text'] + unit['skills']['drive']['text']).downcase.include?(key_words)
        x['idx'] = unit['idx']
        x['en_name'] = 'test'
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
      matched_data << check_stats_for_keywords(main_db_dump,words, unit['en_name'])
    end

    [matched_names, matched_data.flatten.uniq]

  end


end
