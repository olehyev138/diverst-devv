class Field < ActiveRecord::Base
  belongs_to :enterprise
  has_one :saml_association
end
