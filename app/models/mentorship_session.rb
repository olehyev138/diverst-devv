class MentorshipSession < ActiveRecord::Base
    # associations
    belongs_to :user
    belongs_to :mentoring_session

    # validations
    validates :user,                presence: true
    validates :role,                presence: true
    validates :mentoring_session,   presence: true, :on => :update
    
    validates_uniqueness_of :user, scope: [:mentoring_session]
end
