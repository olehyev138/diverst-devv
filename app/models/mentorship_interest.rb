class MentorshipInterest < BaseClass
    # associations
    belongs_to :user
    belongs_to :mentoring_interest
    
    # validations
    validates :user,                presence: true
    validates :mentoring_interest,  presence: true
end
