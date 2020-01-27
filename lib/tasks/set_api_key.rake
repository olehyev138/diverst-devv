desc 'Set a new, given API key'
task :set_api_key, [:key] => [:environment] do |task, args|
  api_key = ApiKey.first
  api_key.key = args[:key]
  api_key.save!
end
