class FieldData < ApplicationRecord
  include FieldData::Actions

  belongs_to :field_user, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :field_user
  validate :same_parent, unless: -> { Rails.env.test? }

  def deserialized_data
    case field.type
    when 'SelectField'
      JSON.parse(data)[0]
    else
      data
    end
  end

  private

  def same_parent
    unless field.field_definer_id == field_user.field_definer_id
      errors.add(:field, 'Field and field_user must have same parent')
    end
  end
end
