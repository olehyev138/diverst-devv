class GenericGraphsTopGroupsByViewsDownloadJob < ActiveJob::Base
    queue_as :default

    def perform(user_id, enterprise_id, erg_text, demo, from_date, to_date)
        user = User.find_by_id(user_id)
        return if user.nil?

        enterprise = Enterprise.find_by_id(enterprise_id)
        return if enterprise.nil?

        csv = demo ? enterprise.generic_graphs_demo_top_groups_by_views_csv(erg_text) : enterprise.generic_graphs_non_demo_top_groups_by_views_csv(erg_text, from_date, to_date)
        file = CsvFile.new(user_id: user.id, download_file_name: "views_per_#{erg_text}")

        file.download_file = StringIO.new(csv)
        file.download_file.instance_write(:content_type, 'text/csv')
        file.download_file.instance_write(:file_name, "views_per_#{erg_text}.csv")

        file.save!
    end
end
