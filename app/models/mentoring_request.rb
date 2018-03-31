class MentoringRequest < ActiveRecord::Base
    # associations
    has_many :mentoring_request_interests
    has_many :mentoring_interests, :through => :mentoring_request_interests
    
    # validations
    validates :type,    presence: true
    validates :status,  presence: true
end
