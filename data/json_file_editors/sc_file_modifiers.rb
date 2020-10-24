require 'pry'

############### Soulcard Pic files RENAMER
def sc_pic_renamer
  # You'd have to update and grab all the pc0### keys from the db file since the file gets updated, but the static keys array doesn't.
  keys = ["pc001_01", "pc002_01", "pc003_01", "pc004_01", "pc005_01", "pc006_01", "pc007_01", "pc008_01", "pc009_01", "pc011_01", "pc012_01", "pc013_01", "pc014_01", "pc015_01", "pc016_01", "pc019_01", "pc021_01",
    "pc022_01", "pc023_01", "pc024_01", "pc028_01", "pc029_01", "pc030_01", "pc031_01", "pc035_01", "pc036_01", "pc037_01", "pc038_01", "pc039_01", "pc040_01", "pc042_01", "pc043_01", "pc044_01", "pc045_01", "pc046_01",
    "pc047_01", "pc048_01", "pc049_01", "pc050_01", "pc051_01", "pc053_01", "pc054_01", "pc055_01", "pc056_01", "pc057_01", "pc061_01", "pc062_01", "pc063_01", "pc065_01", "pc066_01", "pc067_01", "pc068_01", "pc069_01",
    "pc070_01", "pc071_01", "pc073_01", "pc074_01", "pc076_01", "pc077_01", "pc078_01", "pc082_01", "pc083_01", "pc084_01", "pc085_01", "pc088_01", "pc089_01", "pc090_01", "pc091_01", "pc092_01", "pc093_01", "pc094_01",
    "pc095_01", "pc097_01", "pc099_01", "pc101_01", "pc103_01", "pc104_01", "pc105_01", "pc106_01", "pc107_01", "pc108_01", "pc109_01", "pc112_01", "pc114_01", "pc118_01", "pc124_01", "pc127_01", "pc131_01", "pc132_01",
    "pc133_01", "pc134_01", "pc135_01", "pc137_01", "pc141_01", "pc142_01", "pc151_01", "pc152_01", "pc153_01", "pc155_01", "pc156_01", "pc159_01", "pc162_01", "pc165_01", "pc166_01", "pc167_01", "pc175_01", "pc176_01",
    "pc182_01", "pc185_01", "pc191_01", "pc192_01", "pc193_01", "pc194_01", "pc198_01", "pc199_01", "pc200_01", "pc201_01", "pc202_01", "pc203_01"]

  puts "Renaming Files..."

  folder_path = './renamed/'
  puts "Keys size #{keys.size}"
  puts Dir.glob('./' + '*.png').size

  Dir.glob('./' + '*.png').sort_by {|n| [n[4],n[10..14].to_i]}.each_with_index do |f, idx|
       p filename = File.basename(f, File.extname(f))
      File.rename(f, folder_path + keys[idx] + File.extname(f))
  end

  puts "Renaming complete."
end

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

    attribute_type = %w(none water fire forest light dark)
    role_type = %w(none attacker defencer balancer supporter exp upgrade over_limit max_ext)
    restriction_file = JSON.parse(File.read('./json_db/jp_dump/ITEM_OPTION_DATA.json'))
    sc_reflist = fetch_json_data('soulcardref')
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
      File.open('data/sc/jp/soulcardRefListJp.json', 'w') { |file| file.write(x.to_json) }

  end

#############################
