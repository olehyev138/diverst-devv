require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(1.hour, 'Handle expired jobs') { HandleMatchExpirationJob.perform_later }
every(1.hour, 'Update cached segment members') { Segment.update_all_members }
every(1.day, 'Regenerate firebase tokens') { GenerateFirebaseTokensJob.perform_later }