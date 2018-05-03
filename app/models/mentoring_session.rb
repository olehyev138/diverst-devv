class MentoringSession < ActiveRecord::Base
    # associations
    belongs_to :creator,    :class_name => "User"
    belongs_to :enterprise
    
    has_many :mentoring_ratings
    has_many :resources
    
    has_many :mentoring_session_topics
    has_many :mentoring_interests, :through => :mentoring_session_topics
    has_many :mentorship_sessions
    has_many :users, :through => :mentorship_sessions
    has_many :mentorship_ratings
        
    accepts_nested_attributes_for :mentorship_sessions, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :resources,           reject_if: :all_blank, allow_destroy: true
    
    # validations
    validates :start,   presence: true
    validates :end,     presence: true
    validates :status,  presence: true
    validates :format,  presence: true
    
    # scopes
    scope :past,            -> { where("end < ?", Date.today) }
    scope :upcoming,        -> { where("end > ?", Date.today)}
    scope :no_ratings,      -> { includes(:mentorship_ratings).where(:mentorship_ratings => {:id => nil})}
    scope :with_ratings,    -> { includes(:mentorship_ratings).where.not(:mentorship_ratings => {:id => nil})}
    
    def old_session?
        return self.end < Date.today
    end
end
