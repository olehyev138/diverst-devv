class Field < ActiveRecord::Base
  belongs_to :enterprise, inverse_of: :fields

  def string_value(value)
    value
  end

  def serialize_value(value)
    value
  end
end