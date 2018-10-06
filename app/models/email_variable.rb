class EmailVariable < ActiveRecord::Base
    # associations
    belongs_to :email
    belongs_to :enterprise_email_variable
    
     # validations
    validates :email, :enterprise_email_variable, presence: true
    
    def format(value)
        value = value.pluralize if pluralize
        value = value.downcase if downcase
        value = value.titleize if titleize
        value = value.upcase if upcase
        return value
    end
end
