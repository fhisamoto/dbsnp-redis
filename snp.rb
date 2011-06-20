class Snp < Openstruct.new 
  
  KEYS = [
    :id, :map_wgt, :snp_type, :chr_hits, :ctg_hits, :total_hits, :chr, :ctg_acc,
    :ctg_ver, :ctg_id, :ctg_pos, :chr_pos, :local_loci, :avg_het, :se_het,:max_prob,
    :validated, :genotypes, :linkouts, :orig_build, :upd_build, :alternate_ref
  ]
  
  def self.get(key_prefix, chr_pos)
    chr = ChrSnp.load key_prefix
    raw_snp = chr[chr_pos]
    self.new to_params(raw_snp)
  end
  
  private
  
  def self.to_params(raw_snp)
    snp_array = raw_snp.split(',')
    Hash[ *KEYS.zip(snp_array).flatten ]
  end
end