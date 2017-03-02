class Segment < ActiveRecord::Base
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

  def update_indexes
    CacheSegmentMembersJob.perform_later self
    RebuildElasticsearchIndexJob.perform_now(model_name: 'User', enterprise: enterprise)
  end

  def self.update_all_members
    Segment.all.find_each do |segment|
      CacheSegmentMembersJob.perform_later segment
    end
  end
end
