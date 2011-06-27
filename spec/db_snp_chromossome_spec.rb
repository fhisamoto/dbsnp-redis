require File.expand_path(File.dirname(__FILE__) + '/../application')

describe ChrSnp do
  
  before :each do
    @redis = mock()
    APP_CONFIG.should_receive(:redis).and_return(@redis)
    @chr = ChrSnp.new("marafo:chr_1", 0, 20, 10)
  end
  
  it "should create_info" do
    a = [ 'key_prefix', 'marafo:chr_1', 'min', 0, 'max', 20, 'num_buckets', 10, 'width', 2 ]
    @redis.should_receive(:hmset).with('marafo:chr_1:info', *a)
    @chr.create_info
  end
  
  it "should create new ChrSnp" do
  end
  
end