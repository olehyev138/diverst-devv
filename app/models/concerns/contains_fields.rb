module ContainsFields
  extend ActiveSupport::Concern

  included do
    attr_accessor :info

    after_initialize :set_info
    before_validation :transfer_info_to_data
  end

  protected

  def set_info
    self.data = "{}" if self.data.nil?
    json_hash = JSON.parse(self.data)
    self.info = Hash[json_hash.map{|k,v|[ k.to_i, v ]}] # Convert the hash keys to integers since they're strings after JSON parsing
    self.info.extend(FieldData)
  end

  # Called before validation to presist the (maybe) edited info object in the DB
  def transfer_info_to_data
    self.data = JSON.generate self.info
  end
end