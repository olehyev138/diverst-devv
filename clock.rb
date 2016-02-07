require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

# every(1.hour, 'Handle expired matches') { HandleMatchExpirationJob.perform_later }
every(1.hour, 'Update cached segment members') { Segment.update_all_members }
# every(1.day, 'Regenerate firebase tokens') { GenerateFirebaseTokensJob.perform_later }
every(30.minutes, 'Cache participation scores') { CacheParticipationScoresJob.perform_later }
every(10.minutes, 'Sync Yammer users with Diverst users') { SyncYammerUsersJob.perform_later }
every(30.minutes, 'Sync Yammer members') { Group.all.each { |group| SyncYammerGroupJob.perform_later(group) } }
