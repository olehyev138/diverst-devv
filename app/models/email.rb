class Email < ActiveRecord::Base
  belongs_to :enterprise
  has_many :variables, class_name: 'EmailVariable'
end
