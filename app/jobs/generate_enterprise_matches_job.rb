class GenerateEnterpriseMatchesJob < ActiveJob::Base
  queue_as :default

  def perform(enterprise)
    enterprise.employees.each(&:update_match_scores)
  end
end
