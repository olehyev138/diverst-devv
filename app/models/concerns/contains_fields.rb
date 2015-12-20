module ContainsFields
  extend ActiveSupport::Concern

  included do
    before_validation :transfer_info_to_data
  end

  def info
    return @info if !@info.nil?
    self.data = "{}" if self.data.nil?
    json_hash = JSON.parse(self.data)
    @info = Hash[json_hash.map{|k,v|[ k.to_i, v ]}] # Convert the hash keys to integers since they're strings after JSON parsing
    @info.extend(FieldData)
  end

  protected

  # Called before validation to presist the (maybe) edited info object in the DB
  def transfer_info_to_data
    self.data = JSON.generate @info if !@info.nil?
  end
end