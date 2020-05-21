class EmailVariable < BaseClass
  # associations
  belongs_to :email
  belongs_to :enterprise_email_variable

  # validations
  validates :email, :enterprise_email_variable, presence: true

  def format(value)
    return '' unless value.is_a? String

    value = value.pluralize if pluralize
    value = value.downcase if downcase
    value = value.titleize if titleize
    value = value.upcase if upcase
    value
  end
end
