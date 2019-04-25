class SegmentGroupScopeRule < BaseClass
  belongs_to :segment
  has_many :groups

  def self.operators
    {
      join: 0,
      intersect: 1
    }
  end

  def operator_name
    SegmentGroupScopeRule.operators.key(operator)
  end
end
