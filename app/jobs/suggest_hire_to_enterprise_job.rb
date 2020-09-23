class SuggestHireToEnterpriseJob < ActiveJob::Base
  queue_as :mailers
  include Rewardable

  def perform(suggested_hire_id)
    return if suggested_hire_id.nil?

    SuggestedHireMailer.suggest_hire(suggested_hire_id).deliver_later
  end
end
