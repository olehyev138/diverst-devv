class MentoringSessionSerializer < ApplicationRecordSerializer
  attributes :creator, :interests, :interest_options

  has_many :mentoring_interests

  def serialize_all_fields
    true
  end

  def interests
    object.mentoring_interests.map { |i| i.name }.join(', ')
  end

  def interest_options
    MentoringInterest.all.as_json
  end

  def creator
    UserMentorshipLiteSerializer.new(object.creator).as_json
  end
end
