class ActiveStorageCleanupJob < ActiveJob::Base
  queue_as :low

  def perform
    # Clears ActiveStorage blobs and their associated files if they aren't associated with an attachment & they're older than 30 minutes
    ActiveStorage::Blob.find_each(batch_size: 500) do |blob|
      blob.purge_later unless blob.identified? || blob.created_at > 30.minutes.ago
    end
  end
end
