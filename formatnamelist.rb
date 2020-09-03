

module FormatNameList

  def combine_names_json(name_param, code_param)
    # this method checks Two json files and combines the matched details
    # it calls a second method and dumps the data in a reference json file.

    kr_db = JSON.parse(File.read('data/CharacterDatabaseJp.json'))
    en_db = JSON.parse(File.read('data/oldjpbaridb.json'))
    new_unit = []

    if !code_param.nil?
      idx_of_code = kr_db.find_index {|k,_| next if k['skins'] == [];(k['skins'].keys[0][0..4] + '01') == code_param}
    else
      idx_of_code = en_db.find_index do |k,_|
        next if k['region'] != 'jp'

        name_arr = k['kname'].nil? ? ["NA"] : k['kname'].split(" ")
        matched_name = k['name'] if k['name'].include?(name_param) || k['kname'].include?(name_param) #checks if the kr name matches the eng name

        found = name_arr.any? do |name_part|
          # finds the index of the unit in the list
          name_part.downcase.include?(name_param.downcase)
        end

        return false if (matched_name.nil? && found == false)
        return false if (found == false)
        return false if (matched_name.nil?)
        true
      end
    end

    kr_db.each_with_index do |character1, counter|
      break if idx_of_code != nil
      next if character1['grade'] < 3
      idx = character1['idx']
      krname = character1['name']
      char_code = character1['skins'].keys[0][0..4] + '01'
      jp_name1 = character1['skins'].values[0].split(" ")[0]
      jp_name2 = character1['skins'].values[0].split(" ")[1] # changed from 0
      matched_name = ''

      array_idx = en_db.find_index do |k,_|
        next if k['region'] != 'jp'

  ### these two lines below is doubled from above. Might be redundant. remove if can.
        name_arr = k['kname'].nil? ? ["NA"] : k['kname'].split(" ")
        matched_name = k['name'] if k['kname'].include?(krname) #checks if the kr name matches the eng name

        found = name_arr.any? do |name_part|
          # finds the index of the unit in the list
          (name_part.downcase.include?(krname.downcase) || name_part.downcase.include?(jp_name1.downcase) || name_part.downcase.include?(jp_name2.downcase)) &&
          character1['attribute'].downcase == k['element'].downcase &&
          character1['grade'].to_i == k['starLevel'].to_i &&
          k['region'] == 'jp'
        end
        matched_name.empty? ? found : true
      end

      if array_idx.nil?
        # default incase anything is null or being a pain
        new_unit =
        [idx = idx,
        code = char_code,
        jp_name = jp_name2,
        en_name = matched_name,
        kr_name = krname,
        img1 = "img?",
        img2 = "img?",
        img3 = "img?"]
      else
        new_unit =
        [idx = idx,
        code = char_code,
        jp_name = jp_name2,
        en_name = en_db[array_idx]['name'],
        kr_name = krname,
        img1 = en_db[array_idx]['image1'],
        img2 = en_db[array_idx]['image2'],
        img3 = en_db[array_idx]['image3']]
      end
      # calls method to save/dump new details

      save_eng_name_and_idx_to_file(new_unit, new_unit)
    end #kr_db end
    data = kr_db[idx_of_code]

    new_unit =
    [idx = data['idx'],
    code = code_param,
    jp_name = data['skins'].values[0].split(" ")[1],
    en_name = name_param,
    kr_name = data['name'],
    img1 = "img?",
    img2 = "img?",
    img3 = "img?"]
    # calls method to save/dump new details

    save_eng_name_and_idx_to_file(new_unit, new_unit)

    name_param
  end

  def save_eng_name_and_idx_to_file(data, new_unit_data)
    name_file = JSON.parse(File.read('data/character_idx_name.json'))

    x = ''
    name_file.each do |k|
       return if k['idx']== data[0]
     end
    x = {
      "idx"=> data[0],
      "code"=> data[1],
      "en_name"=> data[3],
      "jp_name"=> data[2],
      "kr_name": data[4],
      "image1": data[5],
      "image2": data[6],
      "image3": data[7],
      "tiers": "",
      "notes": ""
    }

    name_file << x
      File.open('data/character_idx_name.json', 'w') { |file| file.write(name_file.to_json) }
      # save_eng_name_and_idx_to_file(@char_info, 'Lisa')
      # use the above method call to save a name into the registry json. replace the name in the call.
  end
  # finding data to the untis.

end
