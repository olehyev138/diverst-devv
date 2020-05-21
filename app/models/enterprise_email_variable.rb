class EnterpriseEmailVariable < BaseClass
  # associations
  belongs_to :enterprise

  has_many :email_variables
  has_many :emails, through: :email_variables

  # validations
  validates_length_of :example, maximum: 65535
  validates_length_of :description, maximum: 191
  validates_length_of :key, maximum: 191
  validates :key, :description, presence: true
end
