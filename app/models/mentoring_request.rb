class MentoringRequest < ActiveRecord::Base
    # associations
    has_many :mentoring_request_interests
    has_many :mentoring_interests, :through => :mentoring_request_interests
    
    belongs_to :sender,     :class_name => "Mentorship"
    belongs_to :receiver,   :class_name => "Mentorship"
    
    # validations
    validates :status,      presence: true
    validates :sender,      presence: true
    validates :receiver,    presence: true
end
