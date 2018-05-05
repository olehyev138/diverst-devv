class Email < ActiveRecord::Base
  # associations
  belongs_to :enterprise
  has_many :variables, class_name: 'EmailVariable', dependent: :destroy
  
  # validations
  validates :name, :subject, presence: true
end
