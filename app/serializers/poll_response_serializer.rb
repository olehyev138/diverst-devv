class PollResponseSerializer < ApplicationRecordSerializer
  has_many :field_data

  def initialize(object, options = nil)
    serializer_attributes :user unless object.anonymous
    super
  end

  def serialize_all_fields
    true
  end

  def excluded_keys
    [:user_id]
  end
end
