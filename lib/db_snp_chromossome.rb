class DbSnpChromossome
  DEFAULT_NUM_BUCKETS = 10000

  def initialize(key_prefix, min, max, num_buckets)
    @key_prefix = key_prefix
    @key_info = "#{@key_prefix}:info"
    
    @min = min
    @max = max
    @num_buckets = num_buckets
    @width = (@max - @min) / @num_buckets
    
    @buckets = []; @chr_pos_values = []
    @num_buckets.times.each do |i|
      @buckets << "#{key_prefix}:b#{i}"
      @chr_pos_values  << @min + @width * i
    end
  end

  def self.load(key_prefix)
    h = APP_CONFIG.redis.hgetall "#{key_prefix}:info"
    raise "ChrSnp info not found" if h.empty?
    return self.new(h['key_prefix'], h['min'].to_i, h['max'].to_i, h['num_buckets'].to_i)
  end

  def self.create(key_prefix, min, max, num_buckets = DEFAULT_NUM_BUCKETS)
    chr_snp = self.new(key_prefix, min.to_i, max.to_i, num_buckets.to_i)
    chr_snp.create_info
    return chr_snp
  end

  def <<(val)
    chr_pos, value = val
    key = get_key(chr_pos)
    APP_CONFIG.redis.zadd(key, chr_pos, value) if key
  end

  def [](chr_pos)
    key = get_key(chr_pos)
    raw_snp = APP_CONFIG.redis.zrangebyscore(key, chr_pos, chr_pos + 1, :with_scores => true).first
    new_snp(raw_snp)
  end

  def in(range)
    ret = []
    a, b = bucket_index_for(range.first), bucket_index_for(range.last)
    (a..b).each do |i| 
      raw_snps = APP_CONFIG.redis.zrangebyscore(@buckets[i], range.first, range.last)
      ret += raw_snps.map { |raw_snp| new_snp(raw_snp) }
    end
    ret
  end

  def create_info
    attributes = [ 'key_prefix', @key_prefix, 'min', @min, 'max', @max, 'num_buckets', @num_buckets, 'width', @width ]
    APP_CONFIG.redis.hmset(@key_info, *attributes)
  end

  private

  def get_key(chr_pos)
    @buckets[ bucket_index_for(chr_pos) ]
  end

  def bucket_index_for(chr_pos)
    ( @num_buckets * (chr_pos - @min).to_f / (@max - @min) ).floor
  end
  
  def new_snp(raw_snp)
    Snp.new(*raw_snp.split(","))
  end
end


