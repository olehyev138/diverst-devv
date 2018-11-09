class GroupMemberUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(member)
    member.__elasticsearch__.update_document
  end
end
