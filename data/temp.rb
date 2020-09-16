require 'json'
require 'yaml'
require 'pry'



def add_replace(unit, name_key, details)
  unit['tiers'] = details['tier']
  unit['date'] = details['date']
  unit['notes'] = details['notes']
  [unit, name_key + ": updated"]
end


def check_confirm(unit, name, details)
  if unit['en_name'].downcase.include?(name) || unit['image1'].include?(name)
    p "Does this Match?"
    p [unit['en_name'], unit['code'], name]
    answer = gets.chomp

    return true if answer == ''
    return false if answer != ''
end

end

def filter_data
  gldb = JSON.parse(File.read('gl/CharacterDatabaseEn.json'))
  reflist = JSON.parse(File.read('gl/characterRefListGl.json'))
  ymldb = YAML.load_file(File.expand_path("gl/unit_details.yml", __dir__))

  new_ref = []
  updated = []
  missing = []
  reflist.each_with_index do |unit,counter|
    ref_name = unit['en_name'].downcase

    x = gldb.find_index {|k,_| k['idx'] == unit['idx']}
    if gldb[x]['grade'] > 3
      found = false
      ymldb.each do |name, details|
        matched = check_confirm(unit, name, details)

        if matched
          z = add_replace(unit, ref_name, details)
          new_ref << z[0]
          updated << z[1]
          p "----" +z[1]+"----"
          puts
          found = true
          break
        end
      end
      new_ref << unit if !found && new_ref.include?(unit) == false
    end
break if counter > 3
  end
  File.open('gl/characterRefListGl.json', 'w') { |file| file.write(new_ref.to_json) }

  binding.pry
end


filter_data

# JSON.parse(File.read('data/childs/gl/characterRefListGl.json'))
