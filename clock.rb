require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(1.hour, 'Handle expired jobs') { HandleMatchExpirationJob.perform_later }
every(1.hour, 'Update cached group members') { Group.update_all_members }