class MentorshipAvailability < ActiveRecord::Base
    # associations
    belongs_to :user
    
    # validations
    validates :user,    presence: true
    validates :start,   presence: true
    validates :end,     presence: true
    
    validates :start,   date: {after: Date.yesterday, message: 'must be today or in the future'}, on: [:create, :update]
    validates :end,     date: {after: :start, message: 'must be after start'}, on: [:create, :update]
end
