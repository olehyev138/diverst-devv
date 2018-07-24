class ImportCSVJob < ActiveJob::Base
  queue_as :low

  def perform(file_id)

  end
end
