class GenerateFirebaseTokensJob < ActiveJob::Base
  queue_as :default

  def perform
    User.where('firebase_token_generated_at > ?', 5.days.ago).each(&:assign_firebase_token)
  end
end
