class GroupRule < ActiveRecord::Base
  belongs_to :group
  belongs_to :field

  before_save :remove_empty_values
  after_save :update_group_members

  @@operators = {
    equals: 0,
    greater_than: 1,
    lesser_than: 2,
    is_not: 3,
    contains_any_of: 4,
    contains_all_of: 5,
    does_not_contain: 6
  }.freeze

  def self.operators
    @@operators
  end

  def self.operator_text(id)
    operators.select{ |k, v| v == id }.keys[0].to_s.gsub("_", " ")
  end

  def values_array
    JSON.parse read_attribute(:values)
  end

  def followed_by?(employee)
    self.field.validates_rule_for_employee?(rule: self, employee: employee)
  end

  # Returns the array of operators that can be used with a given field's type
  def self.operators_for_field(field)
    case field
    when TextField
      return [operators[:equals], operators[:is_not]]
    when DateField
      return [operators[:greater_than], operators[:lesser_than], operators[:equals], operators[:is_not]]
    when NumericField
      return [operators[:greater_than], operators[:lesser_than], operators[:equals], operators[:is_not]]
    when SelectField
      return [operators[:contains_any_of], operators[:is_not]]
    when CheckboxField
      return [operators[:contains_any_of], operators[:contains_all_of], operators[:does_not_contain]]
    end
  end

  protected

  def update_group_members
    group.update_cached_members
  end

  def remove_empty_values
    self.values = values_array.reject(&:empty?).to_json
  end
end
