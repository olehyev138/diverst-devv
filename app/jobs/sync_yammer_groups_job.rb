class SyncYammerGroupsJob < ActiveJob::Base
  queue_as :default

  def perform(enterprise)
    # Do something later
  end
end
