
module FormatSoulCards

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

  def assign_sc_data_to_template(template, params, name, isprism = false)
    idx = ''
    idx2 = ''
    prisma = 0

    if isprism
      idx = (params['idx'].to_i + 1).to_s
      prisma = 1
    else
      puts 'not prism'
      idx = params['idx']
    end

    params.each do |param_n, value|

        case param_n
        when 'sc_name'
          template[:name] = value
        when 'idx'
          template[:idx] = idx
        when 'pic'
          template[:view_idx] = value
        when "normalstat1"
          type = value.split(" ")[0]
          min = value.split(" ")[1]
          max = value.split(" ")[-1]
          template[:status][type.to_sym] = min
          template[:status_max][type.to_sym] = max
        when "normalstat2"
          type = value.split(" ")[0]
          min = value.split(" ")[1]
          max = value.split(" ")[-1]
          template[:status][type.to_sym] = min
          template[:status_max][type.to_sym] = max
        when "prismstat1"
          type = value.split(" ")[0]
          min = value.split(" ")[1]
          max = value.split(" ")[-1]
          template[:status][type.to_sym] = min
          template[:status_max][type.to_sym] = max
        when "prismstat1"
          type = value.split(" ")[0]
          min = value.split(" ")[1]
          max = value.split(" ")[-1]
          template[:status][type.to_sym] = min
          template[:status_max][type.to_sym] = max
        when 'ability'
          template[:text] = value
        when 'isprism'
          template[:prisma] = prisma
        end
    end

    [idx, template]
  end

  def add_to_sc_reflist(params, idx, idx2, isprism, it_is_new, name, created_on, image)
    code = (params['code'].empty? && it_is_new) ? 'x01' : params['code']
    ref_data = {
      "idx"=> idx,
      "idx2"=> isprism ? idx2 : '',
      "dbcode"=>params['dbcode'].to_i,
      "grade"=>params['grade'].to_i,
      "code"=> code,
      "en_name"=>name,
      "jp_name"=>params['jp_name'],
      "kr_name"=>params['kr_name'],
      "image1"=>image.empty? ? '/images/sc/jp/afternoontrain.jpg' : image,
      "restriction"=> params['restriction'],
      "ability"=> params['ability'],
      "notes"=>params['notes'],
      "date"=>created_on
    }
  end

  def edit_sc_reflist(params, name, sc_ref_list, sc_ref_path)

    ref_location = sc_ref_list.find_index {|k,_| k['idx'] == params['idx'] }
    ref_data = sc_ref_list[ref_location]
    sc_ref_list.delete_at(ref_location)
    locale = REGION == "JAPAN" ? 'jp' : 'en'

    params.each do |k,v|
      if k == 'grade'
        ref_data[k] = v.to_i if ref_data.keys.include?(k)
      elsif k == 'sc_name' && v.empty? == false
        ref_data['en_name'] = v
      elsif k == 'pic'
        ref_data['image1'] = v.include?("/images/sc/") ? v : "/images/sc/#{locale}/#{v}"
      else
        ref_data[k] = v if ref_data.keys.include?(k)
      end
    end
      sc_ref_list << ref_data

      File.open(sc_ref_path, 'w') { |file| file.write(sc_ref_list.to_json) }
  end

  def new_sc_data_template
    template = {
      "idx":"",
      "view_idx":"",
      "name":"",
      "grade":5,
      "status":{
      },
      "status_max":{
      },
      "options":{
        "1":{
          "idx":"",
          "value":""
        }
      },
      "options_max":{
        "1":{
          "idx":"",
          "value":""
        }
      },
      "text_max":"",
      "text":"",
      "prisma":0
  }
  end


  private

  def remove_soulcard(name)
    sc_reflist = fetch_json_data('soulcardref')
    db = fetch_json_data('soulcarddb')

    index = ''
    index2 = ''
    sc_reflist.each {|sc| index = sc['idx'] if sc['en_name'].downcase == name.downcase }
    sc_reflist.each {|sc| index2 = sc['idx2'] if (sc['en_name'].downcase == name.downcase  &&  sc['grade'].to_i == 5) }

    ref_location = sc_reflist.find_index {|k| k['idx'] == index && k['en_name'].downcase == name.downcase }
    db_location = db.find_index {|k,v| k.to_i == index.to_i }
    db_location2 = db.find_index {|k,v| k.to_i == index2.to_i }

    if ref_location.nil? || db.nil?
      session[:message] = "Could not locate and remove that Soulcard!"
      redirect '/sc_edit_list'
    end

    sc_reflist.delete_at(ref_location) if sc_reflist[ref_location]['idx'] == index
    db.to_a.delete_at(db_location) if (db.to_a[db_location][1]['idx'] == index && db.to_a[db_location][1]['name'].downcase == name.downcase)
    db.to_a.delete_at(db_location2) if (db.to_a[db_location2][1]['idx'] == index && db.to_a[db_location2][1]['name'].downcase == name.downcase)

    if REGION == "JAPAN"

      File.open('data/sc/jp/SoulCartasJp.json', 'w') { |file| file.write(db.to_json) }
      File.open('data/sc/jp/soulcardRefListJp.json', 'w') { |file| file.write(sc_reflist.to_json) }
    else
      File.open('data/sc/en/SoulCartasEn.json', 'w') { |file| file.write(db.to_json) }
      File.open('data/sc/en/soulcardRefListEn.json', 'w') { |file| file.write(sc_reflist.to_json) }
    end
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

  def get_sc_image(view_idx, backup_img)
    backup_img = backup_img #.gsub('/images/sc/', '').gsub(/[^a-z^0-9^\.]/i, '')
    main_img = "/images/sc/#{view_idx}.jpg"

    if File.file?(main_img)
      get_image_link(main_img)
    else
      get_image_link(backup_img)
    end
  end

  def filter_grab_soulcard_data(sc_name, prism = false)
  # add_sc_data

    sc_db = JSON.parse(File.read('data/sc/jp/SoulCartasJp.json'))
    sc_reflist = JSON.parse(File.read('data/sc/jp/soulcardRefListJp.json'))

    idx_from_match = ''
    backup_image = ''
    restriction = '' #as fallback untill english translations
    ability = '' #as fallback untill english translations
    notes = ''
    sc_reflist.each do |k|
      if k['en_name'].downcase == sc_name.downcase
        if prism
          idx_from_match = k['idx2']
        else
          idx_from_match = k['idx']
        end

        restriction = k['restriction'] if (!idx_from_match.empty? && restriction.empty?)
        ability = k['ability'] if (!idx_from_match.empty? && ability.empty?)
        backup_image = k['image1'] if (!idx_from_match.empty? && backup_image.empty?)
        notes = k['notes'] if (!idx_from_match.empty? && notes.empty?)
      end
    end

    data = sc_db[idx_from_match]
    return {} if data.nil?
    data['backup_image'] = backup_image
    data['restriction'] = restriction
    data['text'] = ability
    data['notes'] = notes
    data
  end

end
