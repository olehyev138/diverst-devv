class GenericGraphsTopResourcesByViewsDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id, demo, from_date, to_date, scoped_by_models = [])
    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise.nil?

    csv = demo ? enterprise.generic_graphs_demo_top_resources_by_views_csv : enterprise.generic_graphs_non_demo_top_resources_by_views_csv(from_date, to_date, scoped_by_models)
    file = CsvFile.new(user_id: user.id, download_file_name: 'views_per_resource')

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, 'views_per_resource.csv')

    file.save!
  end
end
