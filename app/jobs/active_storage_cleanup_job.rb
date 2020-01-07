class ActiveStorageCleanupJob < ActiveJob::Base
  queue_as :low

  # Clears ActiveStorage blobs and their associated files if they aren't associated with an attachment & they're too old
  #
  # @param blob_lifetime [ActiveSupport::Duration] (30.minutes) the amount of time a blob can live for. If the created_at is older than blob_lifetime ago then it is removed
  # @param batch_size [Integer] (500) the batch size of the `find_each` when iterating through blobs.
  # @note blob_lifetime should stay 30 minutes most of the time. This option is primarily for development to purge unnecessary files
  def perform(blob_lifetime = 30.minutes, batch_size = 500)
    ActiveStorage::Blob.find_each(batch_size: batch_size) do |blob|
      blob.purge unless blob.identified? || blob.created_at > blob_lifetime.ago
    end
  end
end
