class Field < ActiveRecord::Base
  belongs_to :enterprise
  has_one :saml_association

  def deserialize_value(value)
    value
  end

  def serialize_value(value)
    value
  end
end
