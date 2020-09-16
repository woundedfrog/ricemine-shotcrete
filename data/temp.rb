require 'json'
require 'yaml'
require 'pry'



def add_replace(unit, name_key, details)
  binding.pry if name_key == 'moa'
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
      if answer == ''
        answer = true
      else
        answer = false
      end

    answer
end

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


    x = gldb.find_index {|k,_| k['idx'] == unit['idx'] && k['grade'] == 5}
     if unit['code'].include?('m') || (x.nil? && new_ref.include?(unit) == false)

      next
    end

    # if (counter >= 0 && counter < 20)
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
      new_ref << unit if !found || new_ref.include?(unit) == false
    # else
      # new_ref << unit
    # end

  end

  File.open('temp_ref.json', 'w') { |file| file.write(new_ref.to_json) }
  # File.open('childs/gl/characterRefListGl.json', 'w') { |file| file.write(new_ref.to_json) }

  binding.pry
end


filter_data
File.join('data/', 'tooltips.yml')
File.open('tooltips.yml', 'wb') { |f| f.write(@answers) }

# JSON.parse(File.read('data/childs/gl/characterRefListGl.json'))
