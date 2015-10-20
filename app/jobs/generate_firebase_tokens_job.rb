class GenerateFirebaseTokensJob < ActiveJob::Base
  queue_as :default

  def perform
    Employee.where('firebase_token_generated_at > ?', 5.days.ago).each do |employee|
      employee.assign_firebase_token
    end
  end
end
