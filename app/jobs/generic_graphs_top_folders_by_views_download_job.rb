class GenericGraphsTopFoldersByViewsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id, demo, from_date, to_date, scoped_by_models = [])
    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise.nil?

    csv = demo ? enterprise.generic_graphs_demo_top_folders_by_views_csv : enterprise.generic_graphs_non_demo_top_folders_by_views_csv(from_date, to_date, scoped_by_models)
    file = CsvFile.new(user_id: user.id, download_file_name: 'views_per_folder')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
