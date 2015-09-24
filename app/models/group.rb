class Group < ActiveRecord::Base
  belongs_to :enterprise
  has_many :rules, class_name: "GroupRule"
  has_and_belongs_to_many :members, class_name: "Employee"
  after_create :update_cached_members

  accepts_nested_attributes_for :rules, reject_if: :all_blank, allow_destroy: true

  def update_cached_members
    CacheGroupMembersJob.perform_later self
  end

  def self.update_all_members
    Group.all.each do |group|
      CacheGroupMembersJob.perform_later group
    end
  end
end
