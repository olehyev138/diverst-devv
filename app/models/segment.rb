class Segment < ActiveRecord::Base
  belongs_to :enterprise
  has_many :rules, class_name: "SegmentRule"
  has_many :employees_segments
  has_many :members, class_name: "Employee", through: :employees_segments, source: :employee
  has_and_belongs_to_many :polls
  has_and_belongs_to_many :events
  has_and_belongs_to_many :group_messages
  has_and_belongs_to_many :groups, inverse_of: :invitation_segments, join_table: "invitation_segments_groups"

  accepts_nested_attributes_for :rules, reject_if: :all_blank, allow_destroy: true

  after_commit :update_cached_members

  def update_cached_members
    puts "888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
    CacheSegmentMembersJob.perform_later self
  end

  def self.update_all_members
    Segment.all.each do |segment|
      CacheSegmentMembersJob.perform_later segment
    end
  end
end
