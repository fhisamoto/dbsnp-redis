class Snp < Struct.new(*KEYS)
  def to_json(*options)
    map = Hash[ *self.members.collect { |m| [ m, self[m] ] }.flatten ]
    map.to_json(*options)
  end
end