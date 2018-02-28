class PolicyGroup < ActiveRecord::Base
    # associations
    belongs_to :user
    
    # validations
    validates :user,    presence: true
    validates_uniqueness_of :user

end
