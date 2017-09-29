class GroupMessage < ActiveRecord::Base
    has_many :group_messages_segments
    has_many :segments, through: :group_messages_segments
    has_many :comments, class_name: 'GroupMessageComment', foreign_key: :message_id

    belongs_to :owner, class_name: 'User'
    belongs_to :group

    has_one :news_feed_link, :as => :link, :dependent => :destroy

    validates :group_id,    presence: true
    validates :subject,     presence: true
    validates :content,     presence: true
    validates :owner_id,    presence: true
    
    before_create :build_default_link
    after_create :send_emails

    def users
        if segments.empty?
            group.members
        else
            User
                .joins(:groups, :segments)
                .where(
                    'groups.id' => group.id,
                    'segments.id' => segments.ids
                )
        end
    end

    def owner_name
        return 'Unknown' unless owner.present?

        owner.first_name + owner.last_name
    end

    def send_emails
        GroupMailer.group_message(self).deliver_later
    end

    private

    def build_default_link
        build_news_feed_link(:news_feed_id => group.news_feed.id)
        true
    end
end
