class EnterpriseEmailVariable < ActiveRecord::Base
    # associations
    belongs_to :enterprise
    
    has_many :email_variables
    has_many :emails, :through => :email_variables
    
     # validations
    validates :key, :description, presence: true
end
