class FieldData < ApplicationRecord
  include FieldData::Actions

  belongs_to :field_user, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :field_user

  def deserialized_data
    field.deserialize_value(data)
  end

  def self.[](field)
    case field
    when Symbol, String then super(field)
    when Field then find_by(field: field).deserialized_data
    else raise ArgumentError
    end
  end

  def self.[]=(field, data)
    case field
    when Symbol, String then super(field, data)
    when Field then find_by(field: field).update(data: field.serialize_value(data))
    else raise ArgumentError
    end
  end

  private

  def same_parent
    unless field.field_definer_id == field_user.field_definer_id
      errors.add(:field, 'Field and field_user must have same parent')
    end
  end
end
