class GroupRule < ActiveRecord::Base
  belongs_to :group
  belongs_to :field

  @@operators = {
    equals: 0,
    is_between: 1,
    greater_than: 2,
    lesser_than: 3,
    is_not: 4,
    contains: 5,
    does_not_contain: 6
  }.freeze

  def self.operators
    @@operators
  end

  def values
    JSON.parse read_attribute(:values)
  end

  def followed_by?(employee)
    self.field.validates_rule_for_employee?(rule: self, employee: employee)
  end
end
