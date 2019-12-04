class FieldData < ApplicationRecord
  belongs_to :user
  belongs_to :field

  def deserialized_data
    case field.type
    when 'SelectField'
      JSON.parse(data)
    else
      data
    end
  end
end
