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
    
    validates :start,   date: {after: Date.yesterday, message: 'must be today or in the future'}, on: [:create, :update]
    validates :end,     date: {after: :start, message: 'must be after start'}, on: [:create, :update]
    
    # scopes
    scope :past,            -> { where("end < ?", Time.now.utc) }
    scope :upcoming,        -> { where("end > ?", Time.now.utc)}
    scope :no_ratings,      -> { includes(:mentorship_ratings).where(:mentorship_ratings => {:id => nil})}
    scope :with_ratings,    -> { includes(:mentorship_ratings).where.not(:mentorship_ratings => {:id => nil})}
    
    before_create :set_room_name
    
    def old_session?
        return self.end < Date.today
    end
    
    def set_room_name
        self.video_room_name = "#{enterprise.name}#{SecureRandom.hex(10)}"
    end
    
    def can_start(user_id)
        return false if access_token.present?
        return mentorship_sessions.where(:user_id => user_id, :role => "presenter").count > 0 && Time.now.utc + 5.minutes > start.utc
    end
end
