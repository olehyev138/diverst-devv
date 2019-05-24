class ApiKey < ApplicationRecord
  has_secure_token :key

  # associations
  belongs_to :enterprise

  # one unique key
  validates_uniqueness_of :key

  # one unique partner
  validates_uniqueness_of :enterprise_id, message: 'Already has an API key'
end
