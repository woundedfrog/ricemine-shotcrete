

module FormatNameList
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

  def combine_names_json(name_param, code_param)
    # this method checks Two json files and combines the matched details
    # it calls a second method and dumps the data in a reference json file.
    if !code_param.nil?
      code_param = code_param + "_01" if !code_param.include?("_01") && code_param.size < 6
      code_param = ('c' + code_param) if !code_param.include?('c') || !code_param.include?('m')
    end
    jp_db = JSON.parse(File.read('data/CharacterDatabaseJp.json'))
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
              img1 = "img?",
              img2 = "img?",
              img3 = "img?"]
    else
      fallback_code = en_db.find_index {|k,_| k['name'].downcase.include?(name_param.downcase)}

      new_data = grab_data_from_olddb(fallback_code, jp_db, en_db)
    end


    new_unit = new_data
    return if new_unit.nil?
    # calls method to save/dump new details

    save_eng_name_and_idx_to_file(new_unit, new_unit)

    name_param
  end

  def save_eng_name_and_idx_to_file(data)
    name_file = JSON.parse(File.read('data/character_idx_name.json'))
      yamlf = File.expand_path('data/unit_details.yml', __dir__)
      yaml_data = YAML.load_file(yamlf)

    exists = false
    name_file.each do |k|
      exists = true if k['idx']== data[0]
      break if exists
    end

    if exists
      name_file.map do |unit|
        if unit["idx"] == data[0]
          unit.each_with_index do |(key, value), idx|
            unit[key] = data[idx]
            unit[key] = value if data[idx].nil?
          end
          unit['tiers'] = yaml_data[data[2]]['tier']
          unit['notes'] = yaml_data[data[2]]['notes']
        else
          unit
        end
      end
    else
      x = {
        "idx"=> data[0],
        "code"=> data[1],
        "en_name"=> data[2],
        "jp_name"=> data[3],
        "kr_name"=> data[4],
        "image1"=> data[5],
        "image2"=> data[6],
        "image3"=> data[7],
        "tiers"=> yaml_data[data[2]]['tier'],
        "notes"=> yaml_data[data[2]]['notes']
      }

      name_file << x
    end

      File.open('data/character_idx_name.json', 'w') { |file| file.write(name_file.to_json) }
      # save_eng_name_and_idx_to_file(@char_info, 'Lisa')
      # use the above method call to save a name into the registry json. replace the name in the call.
  end
  # finding data to the untis.

end
