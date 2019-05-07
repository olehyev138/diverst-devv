class GenericGraphsMentoringSessionsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id, erg_text, from_date, to_date)
    user = User.find_by_id(user_id)
      return if user.nil?

      enterprise = Enterprise.find_by_id(enterprise_id)
      return if enterprise.nil?

      csv = enterprise.generic_graphs_mentoring_sessions_csv(erg_text, from_date, to_date)
      file = CsvFile.new(user_id: user.id, download_file_name: 'graph_group_mentoring_sessions')

      file.download_file = StringIO.new(csv)
      file.download_file.instance_write(:content_type, 'text/csv')
      file.download_file.instance_write(:file_name, 'graph_group_mentoring_sessions.csv')

      file.save!
  end
end
