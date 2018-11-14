class GroupMemberUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    member = User.find_by_id(id)
    return if member.nil?

    begin
      member.__elasticsearch__.update_document
    rescue
    end
  end
end
