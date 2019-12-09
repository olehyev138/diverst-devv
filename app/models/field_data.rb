class FieldData < ApplicationRecord
  belongs_to :user
  belongs_to :field

  def deserialized_data
    case field.type
    when 'SelectField'
      JSON.parse(data)[0]
    else
      data
    end
  end
end
