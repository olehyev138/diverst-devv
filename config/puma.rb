min_threads = Integer(ENV['MIN_THREADS'] || 1)
max_threads = Integer(ENV['MAX_THREADS'] || 16)
threads min_threads, max_threads

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'