class Segment < ActiveRecord::Base
    extend Enumerize

    enumerize :active_users_filter, default: :both_active_and_inactive, in: [
                                        :both_active_and_inactive,
                                        :only_active,
                                        :only_inactive
                                    ]

    has_one :parent_segment, class_name: "Segmentation", foreign_key: :child_id
    has_one :parent, class_name: 'Segment', through: :parent_segment, source: :parent
    
    has_many :children, class_name: "Segmentation", foreign_key: :parent_id
    has_many :sub_segments, class_name: 'Segment', through: :children, source: :child, dependent: :destroy

    belongs_to :enterprise
    belongs_to :owner, class_name: "User"
    has_many :rules, class_name: 'SegmentRule'
    has_many :users_segments
    has_many :members, class_name: 'User', through: :users_segments, source: :user, dependent: :destroy
    has_many :polls_segments
    has_many :polls, through: :polls_segments
    has_many :events_segments
    has_many :events, through: :events_segments
    has_many :group_messages_segments
    has_many :group_messages, through: :group_messages_segments
    has_many :invitation_segments_groups
    has_many :groups, inverse_of: :invitation_segments, through: :invitation_segments_groups
    has_many :initiative_segments
    has_many :initiatives, through: :initiative_segments

    accepts_nested_attributes_for :rules, reject_if: :all_blank, allow_destroy: true

    after_commit :update_indexes

    validates_presence_of :enterprise

    def general_rules_followed_by?(user)
        case active_users_filter
        when 'only_active'
            return user.active?
        when 'only_inactive'
            return !user.active?
        else
            return true
        end
    end

    def update_indexes
        return if enterprise.nil?
        CacheSegmentMembersJob.perform_later self
        RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
    end

    def self.update_all_members
        Segment.all.find_each do |segment|
            CacheSegmentMembersJob.perform_later segment
        end
    end
end
