require 'json'
require 'yaml'
require 'pry'



def add_replace(unit, name_key, details, not_exist_yet = false)
  # binding.pry if name_key == 'moa'
  n_unit = {}
  if not_exist_yet == true

  n_unit['idx'] = unit['idx']
  n_unit['code'] = details
  n_unit['en_name'] = name_key
  n_unit['jp_name'] = ''
  n_unit['kr_name'] = unit['name']
  n_unit['image1'] = details
  n_unit['image2'] = ''
  n_unit['image3'] = ''
  n_unit['tiers'] = ''
  n_unit['notes'] = ''
  n_unit['date'] = '2019-4-21'


    p [n_unit, name_key + ": updated"]
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
    p [unit['en_name'], unit['code'], name]

      answer = gets.chomp
      if answer == ''
        answer = true
      else
        answer = false
      end

      answer
  end
end

def add_units_without_ref
  ## this is used to add units to the ref list that exists in the characterdatabase, but not in the ref list.
  gldb = JSON.parse(File.read('childs/gl/CharacterDatabaseEn.json'))
  reflist = JSON.parse(File.read('childs/gl/characterRefListGl.json'))

  new_ref = []
  gldb.each do |unit|
    # if unit['skins'].keys.any? {|l| l.include?("c")} || reflist.any? {|k| k['idx'] == unit['idx']}
    if reflist.any? {|k| k['idx'] == unit['idx'] }
      next
    else
      skin = unit['skins'].sort_by {|k,v| k }[0][0]
      name = unit['skins'].sort_by {|k,v| k }[0][1]
      # binding.pry
      new = add_replace(unit, name, skin, true)
      new_ref << new[0] unless new_ref.include?(new[0])
    end
  end
  binding.pry
File.open('temp_ref.json', 'w') { |file| file.write(new_ref.to_json) }

end


def filter_data
  gldb = JSON.parse(File.read('childs/gl/CharacterDatabaseEn.json'))
  reflist = JSON.parse(File.read('childs/gl/characterRefListGl.json'))
  ymldb = YAML.load_file(File.expand_path("unit_details.yml", __dir__))

  new_ref = []
  updated = []
  missing = []

  @counter = 0

  reflist.each_with_index do |unit,counter|
    ref_name = unit['en_name'].downcase



    x = gldb.find_index {|k,_| k['idx'] == unit['idx'] && k['grade'] == 3 }# < change the 3 or 4 or 5 for star rating
     if unit['code'].include?('m') || (x.nil? && new_ref.include?(unit) == false)

      next
    end

    # if (counter >= 0 && counter < 20)
      found = false
      ymldb.each do |name, details|
        # next if details['stars'] != '3'
        matched = check_confirm(unit, name, details)

        if matched
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

    binding.pry
  File.open('temp_ref.json', 'w') { |file| file.write(new_ref.to_json) }
  # File.open('childs/gl/characterRefListGl.json', 'w') { |file| file.write(new_ref.to_json) }

  binding.pry
end

#adds and replaced and updates data from the CharacterDatabaseEn with info from the YML database and updates the reflist
# filter_data

#this updates the ref list with units that weren't found in the above method call.
  add_units_without_ref

File.join('data/', 'tooltips.yml')
File.open('tooltips.yml', 'wb') { |f| f.write(@answers) }

# JSON.parse(File.read('data/childs/gl/characterRefListGl.json'))
