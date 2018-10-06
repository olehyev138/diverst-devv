class MentoringRequestInterest< ActiveRecord::Base
    # associations
    belongs_to  :mentoring_request
    belongs_to  :mentoring_interest
    
    # validations
    validates :mentoring_request,  presence: true
    validates :mentoring_interest, presence: true
end
