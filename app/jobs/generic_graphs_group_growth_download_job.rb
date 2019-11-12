class GenericGraphsGroupGrowthDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id, from_date, to_date, scoped_by_models = [])
    user = User.find_by_id(user_id)
    return if user.nil?

    enterprise = Enterprise.find_by_id(enterprise_id)
    return if enterprise.nil?

    csv = enterprise.generic_graphs_group_growth_csv(from_date, to_date, scoped_by_models)
    file = CsvFile.new(user_id: user.id, download_file_name: 'graph_group_growth')

    file.download_file.attach(io: StringIO.new(csv), filename: "#{file.download_file_name}.csv", content_type: 'text/csv')

    file.save!
  end
end
