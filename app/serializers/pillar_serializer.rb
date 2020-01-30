class PillarSerializer < ApplicationRecordSerializer
  has_many :initiatives

  def serialize_all_fields
    true
  end
end
