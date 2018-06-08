class GroupMessage < ActiveRecord::Base
    has_many :group_messages_segments, dependent: :destroy
    has_many :segments, through: :group_messages_segments, :before_remove => :remove_segment_association
    has_many :comments, class_name: 'GroupMessageComment', foreign_key: :message_id, dependent: :destroy
    has_many :user_reward_actions
    
    belongs_to :owner, class_name: 'User'
    belongs_to :group

    has_one :news_feed_link, :dependent => :destroy

    delegate :increment_view, :to => :news_feed_link
    delegate :total_views, :to => :news_feed_link
    delegate :unique_views, :to => :news_feed_link

    validates :group_id,    presence: true
    validates :subject,     presence: true
    validates :content,     presence: true
    validates :owner_id,    presence: true

    alias_attribute :author, :owner

    before_create :build_default_link

    scope :of_segments, ->(segment_ids) {
      gm_condtions = ["group_messages_segments.segment_id IS NULL"]
      gm_condtions << "group_messages_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
      joins("LEFT JOIN group_messages_segments ON group_messages_segments.group_message_id = group_messages.id")
      .where(gm_condtions.join(" OR "))
    }

    scope :unapproved, -> {joins(:news_feed_link).where(:news_feed_links => {:approved => false})}
    scope :approved, -> {joins(:news_feed_link).where(:news_feed_links => {:approved => true})}


    def comments_count
        if group.enterprise.enable_pending_comments?
            comments.approved.count
        else
            comments.count
        end
    end

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

    # call back to delete news link segment associations
    def remove_segment_association(segment)
        group_messages_segment = self.group_messages_segments.where(:segment_id => segment.id).first
        group_messages_segment.news_feed_link_segment.destroy
    end

    private

    def build_default_link
        build_news_feed_link(:news_feed_id => group.news_feed.id)
        true
    end
end
