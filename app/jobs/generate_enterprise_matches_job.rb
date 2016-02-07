class GenerateEnterpriseMatchesJob < ActiveJob::Base
  queue_as :default

  def perform(enterprise)
    enterprise.users.each(&:update_match_scores)
  end
end
