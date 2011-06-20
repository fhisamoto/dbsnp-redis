require 'redis'

REDIS = Redis.new

require '../chr_snp'
require '../db_snp_importer'

def import_file(file_name, max_chr_pos)
  importer = DbSnpImporter.new(file_name)
  max = max_chr_pos ? max_chr_pos.to_i : importer.max_chr_pos
  
  a = ChrSnp.create 'human:chr_1', 0, max
  importer.import_all(a)
end


import_file(ARGV[0], ARGV[1]) if ARGV[0]