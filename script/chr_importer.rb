require File.expand_path(File.dirname(__FILE__) + '/../application')

def import_file(file_name, key_prefix, max_chr_pos)
  importer = DbSnpImporter.new(file_name)
  max = max_chr_pos ? max_chr_pos.to_i : importer.max_chr_pos
  
  a = DbSnpChromossome.create key_prefix, 0, max
  importer.import_all(a)
end

import_file(ARGV[0], ARGV[1], ARGV[2]) if ARGV[0]