class UpdateMissingFieldDataJob < ActiveJob::Base
  queue_as :default

  def perform(definer_type, definer_id, *ids)
    definer = definer_type.constantize.find(definer_id)
    definer.create_missing_field_data(*ids)
  end
end
