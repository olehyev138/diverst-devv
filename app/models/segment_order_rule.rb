#
# Segment rule to order users based on various fields on the User model
#   - order has *zero* effect if segment `limit` field is not set
#   - through limit - the segment population can be limited to say - `top 10 users with highest sign_in_count`
#
class SegmentOrderRule < ApplicationRecord
  belongs_to :segment

  validates_presence_of :field
  validates_presence_of :operator

  def self.fields
    {
      sign_in_count: 0,
      points: 1
    }
  end

  def self.operators
    {
      ASC: 0,
      DESC: 1
    }
  end

  def field_name
    SegmentOrderRule.fields.key(field)
  end

  def operator_name
    SegmentOrderRule.operators.key(operator)
  end
end
