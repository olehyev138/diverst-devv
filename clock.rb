require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(1.hour, 'Handle expired jobs') { HandleMatchExpirationJob.perform_later }
every(1.hour, 'Update cached segment members') { Segment.update_all_members }
every(1.day, 'Regenerate firebase tokens') { GenerateFirebaseTokensJob.perform_later }
every(30.minutes, 'Cache participation scores') { CacheParticipationScores.perform_later }
every(10.minutes, 'Sync yammer users with enterprise employees') { SyncYammerEmployeesJob.perform_later }