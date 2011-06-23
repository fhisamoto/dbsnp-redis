KEYS = [
  :id, :map_wgt, :snp_type, :chr_hits, :ctg_hits, :total_hits, :chr, :ctg_acc,
  :ctg_ver, :ctg_id, :ctg_pos, :chr_pos, :local_loci, :avg_het, :se_het,:max_prob,
  :validated, :genotypes, :linkouts, :orig_build, :upd_build, :alternate_ref
]

class Snp < Struct.new(*KEYS)
end