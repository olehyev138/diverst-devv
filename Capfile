# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include additional tasks
require 'capistrano/rake'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/rails/migrations' # for running migrations
require 'capistrano/npm'
require 'capistrano/locally'

require 'capistrano/puma'
require 'capistrano/puma/workers'
install_plugin Capistrano::Puma # Default puma tasks

require 'capistrano/rails/console'
require 'capistrano/sidekiq'
require 'capistrano/clockwork'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'rollbar/capistrano3'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
