class Field < ApplicationRecord
  belongs_to :enterprise
  belongs_to :group
  belongs_to :poll
  belongs_to :initiative

  has_many :field_data, class_name: 'FieldData'

  has_many :yammer_field_mappings, foreign_key: :diverst_field_id, dependent: :delete_all

  validates_length_of :field_type, maximum: 191
  validates_length_of :options_text, maximum: 65535
  validates_length_of :saml_attribute, maximum: 191
  validates_length_of :title, maximum: 191
  validates_length_of :type, maximum: 191
  validates :title, presence: true
  validates :title, uniqueness: { scope: :enterprise_id },
                    unless: Proc.new { |object| (object.type == 'SegmentsField' || object.type == 'GroupsField') }, if: :container_type_is_enterprise?

  # Operators
  #  - equals_any_of:
  #     - evaluate if singular value (v1) is in an array (v2) - non commutative
  OPERATORS = {
    equals: 0,
    greater_than_excl: 1,
    lesser_than_excl: 2,
    is_not: 3,
    contains_any_of: 4,
    contains_all_of: 5,
    does_not_contain: 6,
    greater_than_incl: 7,
    lesser_than_incl: 8,
    equals_any_of: 9,
    not_equal_any_of: 10,
    is_part_of: 11
  }

  # generic super operators method
  #  - return all operators
  #  - should be defined by custom field subclasses
  def operators
    Field::OPERATORS
  end

  # Compare two values via a operator as defined by OPERATORS
  #  - not all operators are commutative
  def evaluate(v1, v2, operator)
    case operator
    when OPERATORS[:equals]
      v1 == v2
    when OPERATORS[:greater_than_excl]
      v1 > v2
    when OPERATORS[:lesser_than_excl]
      v1 < v2
    when OPERATORS[:is_not]
      v1 != v2
    when OPERATORS[:equals_any_of]
      v2.is_a?(Array) && (v2.include? v1)
    when OPERATORS[:not_equal_any_of]
      v2.is_a?(Array) && (v2.exclude? v1)
    when OPERATORS[:contains_any_of]
      v1.is_a?(Array) && v2.is_a?(Array) && (v1 & v2).length > 0
    when operators[:contains_all_of]
      v1 == v2
    when operators[:does_not_contain]
      v1.is_a?(Array) && v2.is_a?(Array) && (v1 & v2).length <= 0
    when OPERATORS[:greater_than_incl]
      v1 >= v2
    when OPERATORS[:lesser_than_incl]
      v1 <= v2
    when OPERATORS[:is_part_of]
      v1.downcase.include? v2.downcase
    else
      false
    end
  end

  def container_type_is_enterprise?
    enterprise_id.present?
  end

  # The typical field value flow would look like this:
  #   FORM (input string)
  #   1. process_field_value
  #   MEMORY (ruby object)
  #   2. serialize_value
  #   DATABASE (serialized string)
  #   3. deserialize_value
  #   MEMORY (ruby object)
  #   4. string_value
  #   DISPLAY (formatted string)

  # This transforms the user-input value from the form into the desired format
  def process_field_value(value)
    value
  end

  # This serializes the value stored in memory to save it in the DB
  def serialize_value(value)
    value
  end

  # This is called after fetching the raw value stored in the DB.
  def deserialize_value(value)
    value
  end

  # Returns a well-formatted string representing the value. Used for display.
  def string_value(value)
    value
  end

  def csv_value(value)
    value
  end

  def graphable?
    %w(SelectField CheckboxField NumericField).include? type
  end

  def numeric?
    type == 'NumericField' || type == 'DateField'
  end

  def format_value_name(value)
    value
  end

  def enterprise
    return Enterprise.find_by_id(enterprise_id) if enterprise_id.present?
    return group.enterprise if group_id.present?
    return poll.enterprise if poll_id.present?
    return initiative.enterprise if initiative_id.present?
  end
end
