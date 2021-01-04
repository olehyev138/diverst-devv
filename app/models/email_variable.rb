class EmailVariable < ApplicationRecord
  # associations
  belongs_to :email
  belongs_to :enterprise_email_variable

  # validations
  validates :email, :enterprise_email_variable, presence: true

  def format(value)
    return '' unless value.respond_to? :to_s
    
    string = value.to_s
    string = string.pluralize! if pluralize
    string.downcase! if downcase
    string = string.titleize! if titleize
    string.upcase! if upcase
    string
  end
end
