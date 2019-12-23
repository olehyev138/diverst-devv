class FieldData < ApplicationRecord
  belongs_to :fieldable, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :fieldable
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
    unless field.field_definer_id == fieldable.fields_holder_id
      errors.add(:field, 'Field and Fieldable must have same parent')
    end
  end
end
