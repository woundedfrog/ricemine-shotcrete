require 'json'
require 'yaml'
require 'pry'


def grab_buff_details
  # grabs all the buffs from the game.
  puts "what region?"
  region = $stdin.gets.chomp
  puts "what type (sc/ch)?"
  type = $stdin.gets.chomp

  db = JSON.parse(File.read("../childs/CharacterDatabase#{region.capitalize}.json"))


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

File.open("../childs/BuffsInfo#{region.capitalize}.json", 'w') { |file| file.write(buffs.to_json) }

end

def mass_correct_db_data
 #use keys to find what to edit It edits skills' buff names and info.
 puts "what region?"
 region = $stdin.gets.chomp
 puts "what type (sc/ch)?"
 type = $stdin.gets.chomp

 db = JSON.parse(File.read("../childs/CharacterDatabase#{region.capitalize}.json"))

  # new_db = ''

  return

  db.each do |unit|
    next if  unit['skills']['default']['idx'] == '0'
    unit['skills'].each do |skill, sinfo|

      sinfo['buffs'].each do |bname, binfo|
        if binfo['idx'] == '17000002'
          next
          binfo['name'] = "Instant Heal" unless binfo['name'] = "Instant Heal"
        elsif binfo['idx'] == '17000001'
          next
          binfo['name'] = "Regen" unless binfo['name'] = "Regen"
        elsif binfo['idx'] == '17000021'
          binfo['name'] = "Slide Skill Damage" unless binfo['name'] = "Slide Skill Damage"
          binfo['text'] = 'Increase final damage of slide skills.' unless binfo['text'] = 'Increase final damage of slide skills.'

        end

      end

    end
    unit['skills_ignited'].each do |skill, sinfo|

      sinfo['buffs'].each do |bname, binfo|

        if binfo['idx'] == '17000002'
          next
          binfo['name'] = "Instant Heal" unless binfo['name'] = "Instant Heal"
        elsif binfo['idx'] == '17000001'
          next
          binfo['name'] = "Regen" unless binfo['name'] = "Regen"
        elsif binfo['idx'] == '17000021'
          binfo['name'] = "Slide Skill Damage" unless binfo['name'] = "Slide Skill Damage"
          binfo['text'] = 'Increase final damage of slide skills.' unless binfo['text'] = 'Increase final damage of slide skills.'

        end

      end

    end
  end
  File.open("../childs/CharacterDatabase#{region.capitalize}.json", 'w') { |file| file.write(db.to_json) }

  binding.pry


end

mass_correct_db_data

def add_edit_key_pair_to_reflist
  puts "what region?"
  region = $stdin.gets.chomp
  puts "what type (sc/ch)?"
  type = $stdin.gets.chomp


  if type == 'sc'

    reflist = JSON.parse(File.read("../sc/#{region}/soulcardRefList#{region.capitalize}.json"))
    sort_order = ["idx", "idx2", "dbcode", "grade", "code", "en_name", "jp_name", "kr_name", "image1", "restriction", "ability", "notes", "date", "enabled"]
    new_reflist = reflist.map do |val|
                    val['tiers2'] = '0 0 0 0'
                    val.sort_by { |k,_| sort_order.index(k) }.to_h
                  end

    File.open("../sc/#{region}/soulcardRefList#{region.capitalize}.json", 'w') { |file| file.write(new_reflist.to_json) }
  else

    reflist = JSON.parse(File.read("../childs/#{region}/characterRefList#{region.capitalize}.json"))

    sort_order = ["idx", "code", "en_name", "jp_name", "kr_name", "image1", "image2", "image3", "tiers", "tiers2", "notes", "date", "enabled"]
    new_reflist = reflist.map do |val|
                    val['tiers2'] = '0 0 0 0'
                    val.sort_by { |k,_| sort_order.index(k) }.to_h
                  end
    File.open("../childs/#{region}/characterRefList#{region.capitalize}.json", 'w') { |file| file.write(new_reflist.to_json) }

  end

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

  def add_replace(unit, name_key, details, not_exist_yet = false)
    # binding.pry if name_key == 'moa'
    n_unit = {}
    if not_exist_yet == true

      n_unit['idx'] = unit['idx']
      n_unit['code'] = details
      n_unit['en_name'] = name_key
      n_unit['jp_name'] = name_key
      n_unit['kr_name'] = unit['name']
      n_unit['image1'] = details
      n_unit['image2'] = ''
      n_unit['image3'] = ''
      n_unit['tiers'] = ''
      n_unit['notes'] = ''
      n_unit['date'] = '2020-9-19'


      p [n_unit['code'], name_key + ": updated"]
      [n_unit, name_key + ": updated"]
    else

      unit['tiers'] = details['tier']
      unit['date'] = details['date']
      unit['notes'] = details['notes']
      [unit, name_key + ": updated"]
    end
  end


  def check_confirm(unit, name, details)
    if unit['en_name'].downcase.include?(name) || unit['image1'].include?(name)
      p "Does this Match?"
      p [unit['en_name'], unit['code'], "yml: '#{name}' | #{details['pic']}"]

      answer = $stdin.gets.chomp
      if answer == ''
        answer = true
      else
        answer = false
      end

      answer
    end
  end

  def add_units_without_ref
    ## CAN USE ##
    ## this is used to add units to the ref list that exists in the characterdatabase, but not in the ref list.
    # Change file locations to do it for JP if you need to.
    puts "gg for Global, ENTER for japan(default)"
    answer = $stdin.gets.chomp
    answer = answer == 'gg' ? 'en' : 'jp'

      gldb = JSON.parse(File.read("../childs/#{answer}/CharacterDatabase#{answer.capitalize}.json"))
      reflist = JSON.parse(File.read("../childs/#{answer}/characterRefList#{answer.capitalize}.json"))

    temp_ref_db = JSON.parse(File.read('comparingJsonDb.json')) #this file should contain the UPDATED/most recent databse from Arsylk
    # normal databases

    new_db_data = []
    new_ref_data = []
    gldb.each do |unit|  # you can change 'temp_ref_db' with "gldb" if you want to search missing units from either file
      # if unit['skins'].keys.any? {|l| l.include?("c")} || reflist.any? {|k| k['idx'] == unit['idx']}
      next if unit['skins']==[] || unit['grade'] < 3
      if reflist.any? {|k| k['idx'] == unit['idx'] }
        next
      else
        skin = unit['skins'].sort_by {|k,v| k }[0][0]
        name = unit['skins'].sort_by {|k,v| k }[0][1]
        # binding.pry
        new = add_replace(unit, name, skin, true)
        new_db_data << unit
        new_ref_data << new[0] unless new_ref_data.include?(new[0])
      end
    end
    puts "\nDump REF data only = 'ref' | unit_data only = 'db' | all = ENTER(default)"
    answer = $stdin.gets.chomp

    if answer == "ref"
      # dumps the new ref_db data here to a TEMP file
      File.open('temp_ref.json', 'w') { |file| file.write(new_ref_data.to_json) }
    elsif answer == 'db'
      # dumps the new (missing) database data here to a TEMP file.
      File.open('missing_unit_dump.json', 'w') { |file| file.write(new_db_data.to_json) }
    else
      File.open('temp_ref.json', 'w') { |file| file.write(new_ref_data.to_json) }
      File.open('missing_unit_dump.json', 'w') { |file| file.write(new_db_data.to_json) }
    end
  end


  def filter_data
    puts "gg for Global, ENTER for japan(default)"
    answer = $stdin.gets.chomp
    if answer == "gg"
      gldb = JSON.parse(File.read('childs/en/CharacterDatabaseEn.json'))
      reflist = JSON.parse(File.read('childs/en/characterRefListEn.json'))
    else
      gldb = JSON.parse(File.read('childs/jp/CharacterDatabaseJp.json'))
      reflist = JSON.parse(File.read('childs/jp/characterRefListJp.json'))
    end
    ymldb = YAML.load_file(File.expand_path("unit_details.yml", __dir__))

    new_ref = [] # new referencedb data
    updated = [] # units that were updated
    missing = [] #missing info dumped here to pry searching
    already_matched_names = [] # matched names dumped here

    num = 0
    ymldb = ymldb.select do |key, detail|
      !detail['notes'].empty? && detail['stars'] == '5'
    end

    reflist.each_with_index do |unit,counter|
      ref_name = unit['en_name'].downcase

      x = gldb.find_index {|k,_| k['idx'] == unit['idx'] && k['grade'] == 5 }# < change the 3 or 4 or 5 for star rating

      if unit['code'].include?('m') || (x.nil? && new_ref.include?(unit) == false)

        next
      end

      found = false
      ymldb.each do |name, details|
        # next if details['stars'] != '3'
        matched = check_confirm(unit, name, details) if !already_matched_names.flatten.any? {|n| n.downcase == name.downcase || n.downcase == unit['en_name'].downcase}
        if matched
          # this checks if the names have been used and confirmed as matched, if yes it skips
          already_matched_names << unit['en_name']
          already_matched_names << name
        end

        if matched && details['notes'].downcase != unit['notes'].downcase
          z = add_replace(unit, ref_name, details)
          new_ref << z[0] unless new_ref.include?(z[0])
          updated << z[1]
          p "----" +z[1]+"----"
          puts
          found = true
          break
        end
      end
      new_ref << unit if !found || new_ref.include?(unit) == false
      # else
      # new_ref << unit
      # end

    end

    File.open('temp_ref.json', 'w') { |file| file.write(new_ref.to_json) }
    # File.open('childs/en/characterRefListEn.json', 'w') { |file| file.write(new_ref.to_json) }

  end

  #adds and replaced and updates data from the CharacterDatabaseEn with info from the YML database and updates the reflist
  # filter_data

  #this updates the ref list with units that weren't found in the above method call.
  # add_units_without_ref

# add_edit_key_pair_to_reflist


  # File.join('data/', 'tooltips.yml')
  # File.open('tooltips.yml', 'wb') { |f| f.write(@answers) }

  # JSON.parse(File.read('data/childs/en/characterRefListEn.json'))
