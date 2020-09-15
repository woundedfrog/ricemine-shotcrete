require 'json'
require 'yaml'
require 'pry'

def check_if_exist?(ymldb, name, pic)
  matched = []
  x = ymldb.any? do |uname, udetails|
    name.split(' ').each do |part|
      matched << uname if uname.downcase.include?(part)
      return true if uname.downcase.include?(part)
    end

  end
  binding.pry

end

def check_if_matched

end

def filter_data

  jsondb = JSON.parse(File.read('character_idx_name_gl.json'))
  ymldb = YAML.load_file(File.expand_path("unit_details_gl_2020.yml", __dir__))

  jsondb.each do |unit|
    check_if_exist?(ymldb, unit['en_name'].downcase, unit['image1'])

  end
end


filter_data
