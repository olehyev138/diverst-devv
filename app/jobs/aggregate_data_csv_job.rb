class AggregateDataCsvJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, tables, fields, enterprise_id:)
    tables.each do |metric|
      case metric
      when 'logins'
        data = User.aggregate_sign_ins(enterprise_id: enterprise_id)
      else
        data = User.cached_count_list(
          *(fields[metric]['fields'].map { |fld| fld.to_sym }),
          where: fields[metric]['where'],
          enterprise_id: enterprise_id
        )
      end

      data.sort_by! { |datum| -datum[1] }
      data.map! do |datum|
        [
          User.find(datum[0]).name,
          datum[1]
        ]
      end

      csv_data = CSV.generate do |csv|
        first_row = [
          "#{metric.capitalize} Per User"
        ]

        second_row = [
          'User',
          "Number of #{metric.capitalize}"
        ]

        csv << first_row
        csv << second_row

        data.each do |datum|
          csv << datum
        end

        s, _, _, a, sd = DataAnalyst.calculate_aggregate_data(data)

        csv << []
        csv << ['Sum:', s]
        csv << ['Mean:', a]
        csv << ['Standard Deviation:', sd]
      end

      file = CsvFile.new(user_id: user_id, download_file_name: "#{metric}_per_user")

      file.download_file = StringIO.new(csv_data)
      file.download_file.instance_write(:content_type, 'text/csv')
      file.download_file.instance_write(:file_name, "#{metric}_per_user.csv")

      file.save!
    end
  end
end
