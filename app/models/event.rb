class Event < ActiveRecord::Base

    belongs_to :group
    belongs_to :owner, :class_name => "User"
    
    has_many :budgets, :dependent => :destroy
    has_many :events_segments, :dependent => :destroy
    has_many :segments, through: :events_segments
    has_many :event_attendances, :dependent => :destroy
    has_many :attendees, through: :event_attendances, source: :user
    has_many :event_invitees, :dependent => :destroy
    has_many :invitees, through: :event_invitees, source: :user
    has_many :comments, class_name: "EventComment", :dependent => :destroy
    has_many :fields, :dependent => :delete_all

    scope :past, -> { where('end < ?', Time.current).order(start: :desc) }
    scope :upcoming, -> { where('start > ?', Time.current).order(start: :asc) }
    scope :ongoing, -> { where('start <= ?', Time.current).where('end >= ?', Time.current).order(start: :desc) }

    validates :end, date: {after: :start, message: 'must be after start', :allow_nil => true}, on: [:create, :update]

    has_attached_file :picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: "private"
    validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}

    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

    def time_string
        if start.to_date == self.end.to_date # If the event starts and ends on the same day
            "#{start.to_s :dateonly} from #{start.to_s :ampmtime} to #{self.end.to_s :ampmtime}"
        else
            "From #{start.to_s :datetime} to #{self.end.to_s :datetime}"
        end
    end
end
