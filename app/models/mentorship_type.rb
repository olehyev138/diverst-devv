class MentorshipType < ActiveRecord::Base
    # associations
    belongs_to  :user
    belongs_to  :mentoring_type
    
    # validations
    validates :user,            presence: true
    validates :mentoring_type,  presence: true
end
