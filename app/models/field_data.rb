class FieldData < ApplicationRecord
  include FieldData::Actions

  belongs_to :field_user, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :field_user
  validate :validate_numeric_limit, if: -> { field.is_a? NumericField }
  validate :validate_presence_field_data

  def value
    field.deserialize_value(data)
  end

  def data=(a)
    field_id.present? ? super(field.serialize_value(a)) : super
  end

  private

  def same_parent
    unless field.field_definer_id == field_user.field_definer_id
      errors.add(:field, 'Field and field_user must have same parent')
    end
  end

  def validate_numeric_limit
    if field.max.present? && data.to_i > field.max
      errors.add(:data, "can't be greater than the max value")
    elsif field.min.present? && data.to_i < field.min
      errors.add(:data, "can't be less than the min value")
    end
  end

  # Sets an error if data is blank while field is required
  def validate_presence_field_data
    if field&.required && (data.blank? || value.blank?) && !new_record?
      key = field.title.parameterize.underscore.to_sym
      field_user.errors.add(key, "can't be blank")
      errors.add(:data, "can't be blank")
    end
  end
end
