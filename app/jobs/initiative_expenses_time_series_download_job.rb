class InitiativeExpensesTimeSeriesDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, initiative_id, time_from = nil, time_to = nil)
    user = User.find_by_id(user_id)
    return if user.nil?

    initiative = Initiative.find_by_id(initiative_id)
    return if initiative.nil?

    csv = initiative.expenses_time_series_csv(time_from, time_to)
    file = CsvFile.new(user_id: user.id, download_file_name: 'expenses')

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, 'expenses.csv')

    file.save!
  end
end
