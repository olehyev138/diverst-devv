#
# Segment rule to filter users based on custom user fields
#
class SegmentFieldRule < ApplicationRecord
  belongs_to :segment
  belongs_to :field

  validates :field, presence: true
  validates :field_id, presence: true

  # TODO validate that:
  #  - operator 'matches' with selected field - ie '>=' for a TextField is invalid
  #  - operator is in @@operators

  validates :operator, presence: true
  validates :data, presence: true

  # Find users field_data & compare to field_rule data
  def followed_by?(user)
    # find field data for field_rule field type
    field_data = user.field_data.find_by(field_id: field.id)

    return false unless field_data

    field.evaluate(field_data.deserialized_data, deserialized_data, operator)
  end

  def value
    field.deserialize_value(data)
  end

  def data=(a)
    super(field.serialize_value(a))
  end

  #
  # -------------------------------------------------------------------------------------------------
  # TODO: Everything below here is most likely deprecated & needs to be removed
  # DEPRECATED
  # -------------------------------------------------------------------------------------------------
  #

  def values
    self[:values].presence || '[]'
  end

  def self.operator_text(id)
    operators.select { |_, v| v == id }.keys[0].to_s.tr('_', ' ')
  end

  def values_array
    JSON.parse values
  end

  def followed_by_oldaf?(user)
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
