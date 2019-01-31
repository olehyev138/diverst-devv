class MentoringRequest < ActiveRecord::Base
    # associations
    has_many :mentoring_request_interests
    has_many :mentoring_interests, :through => :mentoring_request_interests
    
    belongs_to :enterprise
    belongs_to :sender,     :class_name => "User"
    belongs_to :receiver,   :class_name => "User"
    
    # validations
    validates :status,      presence: true
    validates :sender,      presence: true
    validates :receiver,    presence: true
    
    # only allow one unique request per sender
    validates_uniqueness_of :sender, scope: [:receiver], :message => "There's already a pending request"
    
    after_create :notify_receiver

    scope :mentor_requests, -> { where(:mentoring_type => 'mentor') }
    scope :mentee_requests, -> { where(:mentoring_type => 'mentee') }

    def notify_receiver
        MentorMailer.new_mentoring_request(id).deliver_later
    end
    
    def notify_declined_request
        MentorMailer.notify_declined_request(receiver_id, sender_id).deliver_later
    end
    
    def notify_accepted_request
        MentorMailer.notify_accepted_request(receiver_id, sender_id).deliver_later
    end

end
