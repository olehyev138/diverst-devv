class MentoringInterest < ActiveRecord::Base
    # associations
    has_many :mentorship_interests
    has_many :users, :through => :mentorship_interests
    
    # validations
    validates :name,  presence: true
    
    # we downcase the name in order to allow for searching
    before_save { |m| m.name = m.name.downcase }
    
end
