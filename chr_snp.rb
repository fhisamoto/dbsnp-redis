class ChrSnp
  DEFAULT_NUM_BUCKETS = 10000

  def self.load(key_prefix)
    h = REDIS.hgetall "#{key_prefix}:info"
    raise "ChrSnp info not found" if h.empty?
    return self.new h['key_prefix'], h['min'].to_i, h['max'].to_i, h['num_buckets'].to_i
  end

  def self.create(key_prefix, min, max, num_buckets = DEFAULT_NUM_BUCKETS)
    chr_snp = self.new(key_prefix, min.to_i, max.to_i, num_buckets.to_i)
    chr_snp.create_info
    return chr_snp
  end
  
  def initialize(key_prefix, min, max, num_buckets)
    @key_prefix = key_prefix
    @key_info = "#{@key_prefix}:info"
    
    @min = min
    @max = max
    @num_buckets = num_buckets
    @width = (@max - @min) / @num_buckets
    
    @buckets = []
    @num_buckets.times.each { |i| @buckets << "#{key_prefix}:b#{i}" }
    
    self
  end

  def <<(val)
    chr_pos, value = val
    REDIS.zadd get_key(chr_pos), chr_pos, value
  end

  def [](chr_pos)
    key = get_key(chr_pos)
    REDIS.zrangebyscore(key, chr_pos, chr_pos + 1, :with_scores => true).first
  end

  def create_info
    attributes = [ 'key_prefix', @key_prefix, 'min', @min, 'max', @max, 'num_buckets', @num_buckets, 'width', @width ]
    REDIS.hmset(@key_info, *attributes)
  end

  private

  def get_key(chr_pos)
    @buckets[ bucket_index_for(chr_pos) ]
  end

  def bucket_index_for(chr_pos)
    ( (chr_pos - @min).to_f / @width ).floor
  end
end


