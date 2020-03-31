class PageVisitsCsvJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, enterprise_id: nil, page_user_id: nil)
    if page_user_id.present?
      page_user = User.find(page_user_id)
      filename = "#{page_user.file_safe_name}_s_page_visitation"
      pvs = PageVisitation.where(user_id: user_id).order(visits_all: :desc)
    else
      filename = 'total_page_visitation'
      pvs = Enterprise.find(enterprise_id).total_page_visitations.order(visits_all: :desc)
    end
    data = CSV.generate do |csv|
      if page_user.present?
        first_row = [
          'Page Visitation For',
          (User.find(page_user_id).name rescue 'Deleted User')
        ]
      else
        first_row = [
          'Page Visitation For',
          'All user'
        ]
      end

      second_row = [
        'Page Name',
        'Page URL',
        'Visits Past 24H',
        'Visits Past Week',
        'Visits Past Month',
        'Visits Past Year',
        'Total Visits',
      ]

      csv << first_row
      csv << second_row

      pvs.each do |pv|
        visits_row = [
          pv.page_name,
          pv.page_url,
          pv.visits_day,
          pv.visits_week,
          pv.visits_month,
          pv.visits_year,
          pv.visits_all
        ]

        csv << visits_row
      end

      csv << []
      csv << ['As of', Time.now]
    end

    file = CsvFile.new(user_id: user_id, download_file_name: filename)

    file.download_file = StringIO.new(data)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, filename + '.csv')

    file.save!
  end
end
