class Segment < ActiveRecord::Base
    extend Enumerize
    include PublicActivity::Common

    enumerize :active_users_filter, default: :both_active_and_inactive, in: [
                                        :both_active_and_inactive,
                                        :only_active,
                                        :only_inactive
                                    ]

    has_one :parent_segment, class_name: "Segmentation", foreign_key: :child_id
    has_one :parent, class_name: 'Segment', through: :parent_segment, source: :parent

    has_many :children, class_name: "Segmentation", foreign_key: :parent_id, dependent: :destroy
    has_many :sub_segments, class_name: 'Segment', through: :children, source: :child, dependent: :destroy

    belongs_to :enterprise
    belongs_to :owner, class_name: "User"

    has_many :rules, class_name: 'SegmentRule', dependent: :destroy
    has_many :users_segments, dependent: :destroy
    has_many :members, class_name: 'User', through: :users_segments, source: :user, dependent: :destroy
    has_many :polls_segments, dependent: :destroy
    has_many :polls, through: :polls_segments
    has_many :events_segments, dependent: :destroy
    has_many :events, through: :events_segments
    has_many :group_messages_segments, dependent: :destroy
    has_many :group_messages, through: :group_messages_segments
    has_many :invitation_segments_groups, dependent: :destroy
    has_many :groups, inverse_of: :invitation_segments, through: :invitation_segments_groups
    has_many :initiative_segments, dependent: :destroy
    has_many :initiatives, through: :initiative_segments

    validates_presence_of :name
    
    after_commit :update_indexes

    before_destroy :remove_parent_segment

    validates_presence_of :enterprise

    accepts_nested_attributes_for :rules, reject_if: :segment_rule_values_is_nil, allow_destroy: true


    def segment_rule_values_is_nil(attributes)
        attributes['values'].nil? 
    end

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
        CacheSegmentMembersJob.perform_later self
        RebuildElasticsearchIndexJob.perform_later(model_name: 'User', enterprise: enterprise)
    end

    def self.update_all_members
        Segment.all.find_each do |segment|
            CacheSegmentMembersJob.perform_later segment
        end
    end

    def remove_parent_segment
        return if self.parent_segment.nil?
        self.parent_segment.destroy
    end
end
