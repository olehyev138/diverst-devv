class FieldData < ApplicationRecord
  belongs_to :fieldable, polymorphic: true
  belongs_to :field

  validates_presence_of :field
  validates_presence_of :fieldable

  def deserialized_data
    case field.type
    when 'SelectField'
      JSON.parse(data)[0]
    else
      data
    end
  end
end
