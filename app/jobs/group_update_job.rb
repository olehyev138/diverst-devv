class GroupUpdateJob < ActiveJob::Base
  queue_as :default
  
  def perform(group_id)
    group = Group.find_by_id(group_id)
    return if group.nil?

    group.members.includes(:poll_responses).each do |member|
        group.update_elasticsearch_member(member)
    end
  
  end
end