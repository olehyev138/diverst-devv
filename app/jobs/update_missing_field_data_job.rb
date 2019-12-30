class UpdateMissingFieldDataJob < ActiveJob::Base
  queue_as :default

  def perform(field_id)
    field = Field.find(field_id)
    field.field_definer.create_missing_field_data
  end
end

