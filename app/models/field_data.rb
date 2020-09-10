class FieldData < ApplicationRecord
  include FieldData::Actions

  belongs_to :field_user, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :field_user
  validate :validate_numeric_limit, if: -> { field.is_a? NumericField }

  def deserialized_data
    field.deserialize_value(data)
  end

  def data
    field.deserialize_value(super)
  end

  def data=(a)
    super(field.serialize_value(a))
  end

  private

  def same_parent
    unless field.field_definer_id == field_user.field_definer_id
      errors.add(:field, 'Field and field_user must have same parent')
    end
  end

  def validate_numeric_limit
    if data.to_i > field.max
      errors.add(:data, "can't be greater than the max value")
    elsif data.to_i < field.min
      errors.add(:data, "can't be less than the min value")
    end
  end
end
