class PillarSerializer < ApplicationRecordSerializer
  attributes :outcome

  def serialize_all_fields
    true
  end
end
