class MentoringInterest < ActiveRecord::Base
    # associations
    has_many :mentorship_interests
    has_many :users, :through => :mentorship_interests
    
    # validations
    validates :name,  presence: true
end
