class SegmentOrderRule < BaseClass
  belongs_to :segment

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
