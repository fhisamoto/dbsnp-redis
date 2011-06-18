require 'zlib'
require 'redis'

@redis = Redis.new 

KEYS = [
  :id, :map_wgt, :snp_type, :chr_hits, :ctg_hits,
  :total_hits, :chr, :ctg_acc, :ctg_ver, :ctg_id,
  :ctg_pos, :chr_pos, :local_loci, :avg_het, :se_het,
  :max_prob, :validated, :genotypes, :linkouts,
  :orig_build, :upd_build, :alternate_ref 
]

def create_snp(line, key_prefix = "snp")
  values = line.strip.split("\t")
  chr_pos = values[11].to_i
  puts values[11]

  @redis.zadd 'human:chr_1', chr_pos, values.join(',') unless values[11].nil?
end



def import_file(file_name)
  gf = Zlib::GzipReader.open(file_name)
  # skip header
  7.times { gf.readline }
  gf.each_line { |l| create_snp(l) } 
end

import_file(ARGV[0]) if ARGV[0]