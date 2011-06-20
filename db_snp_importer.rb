require 'zlib'

class DbSnpImporter
  
  KEYS = [
    :id, :map_wgt, :snp_type, :chr_hits, :ctg_hits, :total_hits, :chr, :ctg_acc,
    :ctg_ver, :ctg_id, :ctg_pos, :chr_pos, :local_loci, :avg_het, :se_het,:max_prob,
    :validated, :genotypes, :linkouts, :orig_build, :upd_build, :alternate_ref
  ]
  
  def initialize(file_name)
    @file = Zlib::GzipReader.open(file_name)
  end
  
  def import_all(aggregator)
    skip_header
    @file.each_line do |line| 
      values = line.strip.split("\t")
      if values[11]
        chr_pos = values[11].to_i
        # puts [ chr_pos, values.join(',') ]
        aggregator << [ chr_pos, values.join(',') ]
      end
    end
  end

  def max_chr_pos
    skip_header
    max_pos = 0
    @file.each_line do |line| 
      values = line.strip.split("\t")
      pos = values[11].to_i
      max_pos = pos if pos > max_pos 
    end
    max_pos
  end
  
  private
  
  def skip_header
    @file.rewind
    7.times { @file.readline }
  end
end
