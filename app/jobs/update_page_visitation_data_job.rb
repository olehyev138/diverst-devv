class UpdatePageVisitationDataJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    User.find_each do |usr|
      usr.collect_visitation_data
    end
    Ahoy::Visit.destroy_all
  end
end
