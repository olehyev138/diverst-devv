class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available

  # discard_on ActiveJob::DeserializationError
  rescue_from(ActiveJob::DeserializationError) do |exception|
    # Skip job when record is not found
  end
end
