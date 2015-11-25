# This job is fired as soon as two employees accept a match. Here is what is being done here:
#   - Notify the users via a push notification
#   - Create the conversation in Firebase

class HandleAcceptedMatchJob < ActiveJob::Base
  queue_as :default

  def perform(match)
    # Create the Firebase conversation
    base_uri = 'https://diverst.firebaseio.com'
    firebase = Firebase::Client.new(base_uri)
    firebase.set("conversations/#{match.id}", { id: match.id, users: [match.user1.id, match.user2.id] })

    # Notify the users of the match
    match.both_accepted_notification
  end
end