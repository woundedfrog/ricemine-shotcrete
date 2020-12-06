require 'pry'

def search_missing_sc
  puts "what region?"
  region = $stdin.gets.chomp
  puts "what type (sc/ch)?"
  type = $stdin.gets.chomp


db = JSON.parse(File.read("../sc/#{region}/SoulCartas#{region.capitalize}.json"))
reflist = JSON.parse(File.read("../sc/#{region}/soulcardRefList#{region.capitalize}.json"))
keys = db.keys
refkeys = []
  reflist.each do |prof|
    refkeys << prof['idx'] unless refkeys.include?(prof['idx'])
      refkeys << prof['idx2'] unless refkeys.include?(prof['idx2'])
  end
  p missing = (keys.sort - refkeys.sort)
  binding.pry
end
search_missing_sc

def get_key_pair_from_json
  puts "what region?"
  region = $stdin.gets.chomp
  puts "what type (sc/ch)?"
  type = $stdin.gets.chomp


  if type == 'sc'

    reflist = JSON.parse(File.read("../sc/#{region}/soulcardRefList#{region.capitalize}.json"))
    idxs = []
    new_reflist = reflist.each do |val|
                    idxs << val['idx'] unless idxs.include? val['idx']
                    idxs << val['idx2'] unless (val['idx2'] == '' || idxs.include?(val['idx2']) )
                  end
  end
end
# get_key_pair_from_json


def add_edit_key_pair_to_reflist
  puts "what region?"
  answer = gets.chomp
  region = answer


# reflist = JSON.parse(File.read("../childs/#{region}/characterRefList#{region.capitalize}.json"))
reflist = JSON.parse(File.read("../sc/#{region}/soulcardRefList#{region.capitalize}.json"))

  # sort_order = ["idx", "code", "en_name", "jp_name", "kr_name", "image1", "image2", "image3", "tiers", "notes", "date", "enabled"]
  sort_order = ["idx", "idx2", "dbcode", "grade", "code", "en_name", "jp_name", "kr_name", "image1", "restriction", "ability", "notes", "date", "enabled"]
  new_reflist = reflist.map do |val|
                  val['enabled'] = 't'
                  val.sort_by { |k,_| sort_order.index(k) }.to_h
                end


# File.open("../childs/#{region}/characterRefList#{region.capitalize}.json", 'w') { |file| file.write(new_reflist.to_json) }
File.open("../sc/#{region}/soulcardRefList#{region.capitalize}.json", 'w') { |file| file.write(new_reflist.to_json) }

end



############### Soulcard Pic files RENAMER
def sc_pic_renamer
  # You'd have to update and grab all the pc0### keys from the db file since the file gets updated, but the static keys array doesn't.

  puts "what region?"
  answer = gets.chomp
  region = answer

db = JSON.parse(File.read("../sc/#{region}/SoulCartas#{region.capitalize}.json"))

  keys = ["pc001_01", "pc002_01", "pc003_01", "pc004_01", "pc005_01", "pc006_01", "pc007_01", "pc008_01", "pc009_01", "pc011_01", "pc012_01", "pc013_01", "pc014_01", "pc015_01", "pc016_01", "pc019_01", "pc021_01",
    "pc022_01", "pc023_01", "pc024_01", "pc028_01", "pc029_01", "pc030_01", "pc031_01", "pc035_01", "pc036_01", "pc037_01", "pc038_01", "pc039_01", "pc040_01", "pc042_01", "pc043_01", "pc044_01", "pc045_01", "pc046_01",
    "pc047_01", "pc048_01", "pc049_01", "pc050_01", "pc051_01", "pc053_01", "pc054_01", "pc055_01", "pc056_01", "pc057_01", "pc061_01", "pc062_01", "pc063_01", "pc065_01", "pc066_01", "pc067_01", "pc068_01", "pc069_01",
    "pc070_01", "pc071_01", "pc073_01", "pc074_01", "pc076_01", "pc077_01", "pc078_01", "pc082_01", "pc083_01", "pc084_01", "pc085_01", "pc088_01", "pc089_01", "pc090_01", "pc091_01", "pc092_01", "pc093_01", "pc094_01",
    "pc095_01", "pc097_01", "pc099_01", "pc101_01", "pc103_01", "pc104_01", "pc105_01", "pc106_01", "pc107_01", "pc108_01", "pc109_01", "pc112_01", "pc114_01", "pc118_01", "pc124_01", "pc127_01", "pc131_01", "pc132_01",
    "pc133_01", "pc134_01", "pc135_01", "pc137_01", "pc141_01", "pc142_01", "pc151_01", "pc152_01", "pc153_01", "pc155_01", "pc156_01", "pc159_01", "pc162_01", "pc165_01", "pc166_01", "pc167_01", "pc175_01", "pc176_01",
    "pc182_01", "pc185_01", "pc191_01", "pc192_01", "pc193_01", "pc194_01", "pc198_01", "pc199_01", "pc200_01", "pc201_01", "pc202_01", "pc203_01"]


    keys = db.map {|k,v| v['view_idx']}.uniq.sort

  puts "Renaming Files..."
  folder_path = './renamed/'
  puts "Keys size #{keys.size}"
  puts Dir.glob('./sc_img/' + '*.jpg').size

  Dir.glob('./sc_img/' + '*.jpg').sort_by {|n| [n[11],n[17..21].to_i]}.each_with_index do |f, idx|
       p filename = File.basename(f, File.extname(f))
      File.rename(f, folder_path + keys[idx] + File.extname(f))
  end

  puts "Renaming complete."
end
# sc_pic_renamer
############################this formates the NEW SC stats to fit the old style of yaml file
# unused now

def format_new_sc_stats(stats, passive_skill = false)

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

#############################adds restriction from data file to sc_reflist.json file

  def add_sc_restriction_to_scref_file
    # IF you need to make sure all restrictions are correct, use this method.
    # Files needed:soulcarddb.json + ITEM_OPTION_DATA.json.
    # idx from soulcarddb drops first num and adds a 0 to the end to match idx for same sc in ITEM_OPTION_DATA. so 12345 > 23450.

    puts "what region?"
    answer = gets.chomp
    region = answer

    attribute_type = %w(none water fire forest light dark)
    role_type = %w(none attacker defencer balancer supporter exp upgrade over_limit max_ext)
    restriction_file = JSON.parse(File.read("./json_db/#{region}_dump/ITEM_OPTION_DATA.json"))
    sc_reflist = JSON.parse(File.read("../sc/#{region}/soulcardRefList#{region.capitalize}.json"))

    # db = fetch_json_data('soulcarddb')
    x = sc_reflist.map do |k|
      idx = (k['idx'][1..-1] + "0")
      if restriction_file.keys.any? {|nn| nn == idx}
        attribute_idx = restriction_file[idx]['attribute'].to_i
        role_idx = restriction_file[idx]['role'].to_i

        attribute = attribute_type[attribute_idx]
        role = role_type[role_idx]

        attribute = '' if attribute == 'none'
        role = '' if role == 'none'
        info = [attribute.capitalize, role.capitalize].join(" ").rstrip
        info = "None" if info.empty?

        p info

        k['restriction'] = info

      end
      k
    end

      File.open("../sc/#{region}/soulcardRefList#{region.capitalize}.json", 'w') { |file| file.write(x.to_json) }

  end
#############################

def get_names_from_pckfiles(region)
  # You get this files from extracting the locale pack file
  # 00000024 is for scnames
  # 00000008 is for child names
  if region == 'en'
    sc_name = File.open('./json_db/en_dump/00000024.tab').read.split("\r\n") # this is from my pck extractions
  else
    sc_name = File.open('./json_db/jp_dump/00000028.tab').read.split("\r\n") # this is from my pck extractions
  end
  names = {}
  sc_name.each {|line| names[line.split("\t")[0]] = line.split("\t")[1] if line.split("\t")[0][0..1] == '51'}
  names
end

def get_sc_restrictions_from_json(region)
  # you need to get this from arsylk
  restriction_file = JSON.parse(File.read("./json_db/#{region}_dump/ITEM_OPTION_DATA.json"))
  new_file = {}
  restriction_file.each do |idx, info|
    detail = {}
    detail['role'] = info['role']
    detail['attribute'] = info['attribute']
    new_file[idx] = detail
  end
  new_file
end

def generate_whole_new_screflist
  region = 'en'
  db = JSON.parse(File.read("../sc/#{region}/SoulCartas#{region.capitalize}.json"))
  locale_file = JSON.parse(File.read("./json_db/#{region}_dump/locale.json"))
  sc_names = locale_file['files']['8c0a00198ad12ee5']['dict']  #this is from the arsylk locale file.
  sc_names = get_names_from_pckfiles(region)
  restrictions = get_sc_restrictions_from_json(region)

  db_keys  = db.keys
  finished_idx = []
  new_ref_list = []

  db.each_with_index do |(idx,v), counter|
    next if (idx[-1] == '6' && v['grade'] == 5)
    template = {
      "idx": "",
      "idx2": "",
      "dbcode": 0,
      "grade": 0,
      "code": "",
      "en_name": "",
      "jp_name": "",
      "kr_name": "",
      "image1": "",
      "restriction": "",
      "ability": "",
      "notes": "",
      "date": ""
    }

    v.each do |key, value|
      case key
      when 'idx'
        template[key.to_sym] = value unless finished_idx.any? { |id| id == value }
        idx2 = (value.to_i + 1).to_s unless value[-3..-1] == '001'
        if value[-3..-1] != '001'
          if (db[value]['grade'] == 5 && db[idx2]['prisma'] == 1)
            template['idx2'.to_sym] = idx2 unless finished_idx.any? { |id| id == idx2 }
          end
        end
        finished_idx << value
        finished_idx << idx2 unless idx2.nil?
      when 'name'
        if sc_names[idx].include?('\t')
          template['en_name'.to_sym] = sc_names[idx].split("\t")[0]
        else
          template['en_name'.to_sym] = sc_names[idx]
        end
        template['kr_name'.to_sym] = value
      when 'grade'
        template[key.to_sym] = value
      when 'restriction'
        template[key.to_sym] = ''
      when 'text'
        template['ability'.to_sym] = value
      when 'view_idx'
        template['image1'.to_sym] = (value + '.jpg')
      end
      template['date'.to_sym] = '2020-09-01'

    end
      new_ref_list << template unless new_ref_list.include?(template)
  end
  binding.pry
  File.open("../sc/#{region}/soulcardRefList#{region.capitalize}.json", 'w') { |file| file.write(new_ref_list.to_json) }
  add_sc_restriction_to_scref_file

end
# generate_whole_new_screflist
#############################
