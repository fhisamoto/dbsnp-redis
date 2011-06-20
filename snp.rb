require 'ostruct'
require './chr_snp'

class Snp < OpenStruct
  
  KEYS = [
    :id, :map_wgt, :snp_type, :chr_hits, :ctg_hits, :total_hits, :chr, :ctg_acc,
    :ctg_ver, :ctg_id, :ctg_pos, :chr_pos, :local_loci, :avg_het, :se_het,:max_prob,
    :validated, :genotypes, :linkouts, :orig_build, :upd_build, :alternate_ref
  ]
  
  def self.get(params)
    r = []
    params.each_pair do |key, chr_pos|
      if chr_pos.is_a?(Array)
        chr_pos.each { |p| r << get_by_chr_pos(key, p) }
      elsif chr_pos.is_a?(Range)
        r = ChrSnp.load(key).in(chr_pos).map { |i| self.new(to_params(i)) }
      else
        r << get_by_chr_pos(key, chr_pos)
      end
    end
    return r
  end
  
  def self.get_by_chr_pos(key_prefix, chr_pos)
    raw_snp = ChrSnp.load(key_prefix)[chr_pos]
    self.new(to_params(raw_snp)) unless raw_snp.nil?
  end
  
  private
  
  def self.to_params(raw_snp)
    snp_array = raw_snp.split(',')
    Hash[ *KEYS.zip(snp_array).flatten ]
  end
end