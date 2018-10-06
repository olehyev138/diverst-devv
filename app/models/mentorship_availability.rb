class MentorshipAvailability < ActiveRecord::Base
    # associations
    belongs_to :user
    
    # validations
    validates :user,    presence: true
    validates :day,     presence: true
    validates :start,   presence: true
    validates :end,     presence: true
end
