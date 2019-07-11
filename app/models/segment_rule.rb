class SegmentRule < BaseClass
  belongs_to :segment
  belongs_to :field

  validates_length_of :values, maximum: 65535
  validates :field, presence: true
  validates :field_id, presence: true

  # TODO validate that operator is in @@operators
  validates :operator, presence: true
  validates :values, presence: true

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

  def values
    self[:values].presence || '[]'
  end

  def self.operator_text(id)
    operators.select { |_, v| v == id }.keys[0].to_s.tr('_', ' ')
  end

  def values_array
    JSON.parse values
  end

  def followed_by?(user)
    return true if field.nil?

    field.validates_rule_for_user?(rule: self, user: user)
  end

  # Returns the array of operators that can be used with a given field's type
  def self.operators_for_field(field)
    case field
    when TextField
      [operators[:equals], operators[:is_not]]
    when DateField
      [operators[:greater_than], operators[:lesser_than], operators[:equals], operators[:is_not]]
    when NumericField
      [operators[:greater_than], operators[:lesser_than], operators[:equals], operators[:is_not]]
    when SelectField
      [operators[:contains_any_of], operators[:is_not]]
    when CheckboxField
      [operators[:contains_any_of], operators[:contains_all_of], operators[:does_not_contain]]
    end
  end

  protected

  def update_segment_members
    segment.update_cached_members
  end

  def remove_empty_values
    self.values = values_array.reject(&:empty?).to_json
  end
end
