class OutcomeSerializer < ApplicationRecordSerializer
  attributes :group

  has_many :pillars

  def serialize_all_fields
    true
  end
end
