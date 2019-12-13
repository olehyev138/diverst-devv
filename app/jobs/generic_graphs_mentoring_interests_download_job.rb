class GenericGraphsMentoringInterestsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id)
    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise.nil?

    csv = enterprise.generic_graphs_mentoring_interests_csv
    file = CsvFile.new(user_id: user.id, download_file_name: 'mentoring_interests')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
