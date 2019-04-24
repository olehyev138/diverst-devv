class Segment < BaseClass
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

    # Rules
    has_many :field_rules, class_name: 'SegmentRule', dependent: :destroy
    has_many :order_rules, class_name: 'SegmentOrderRule', dependent: :destroy

    has_many :users_segments, dependent: :destroy
    has_many :members, class_name: 'User', through: :users_segments, source: :user, dependent: :destroy
    has_many :polls_segments, dependent: :destroy
    has_many :polls, through: :polls_segments
    has_many :group_messages_segments, dependent: :destroy
    has_many :group_messages, through: :group_messages_segments
    has_many :invitation_segments_groups, dependent: :destroy
    has_many :groups, inverse_of: :invitation_segments, through: :invitation_segments_groups
    has_many :initiative_segments, dependent: :destroy
    has_many :initiatives, through: :initiative_segments


    validates_presence_of :name
    validates :name, uniqueness: { scope: :enterprise_id }

    after_commit :cache_segment_members, on: [:create, :update]

    before_destroy :remove_parent_segment

    validates_presence_of :enterprise

    # Rule attributes
    accepts_nested_attributes_for :field_rules, reject_if: :segment_rule_values_is_nil, allow_destroy: true

    def rules
      field_rules
    end

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

    def cache_segment_members
        CacheSegmentMembersJob.perform_later self.id
    end

    def self.update_all_members
        Segment.all.find_each do |segment|
            CacheSegmentMembersJob.perform_later segment.id
        end
    end

    def remove_parent_segment
        return if self.parent_segment.nil?
        self.parent_segment.destroy
    end
end
