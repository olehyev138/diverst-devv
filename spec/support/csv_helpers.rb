module CsvHelpers
  def create_import_spreadsheet(head, rows)
    data = CSV.generate do |csv|
      csv << head
      rows.each do |row|
        csv << row
      end
    end
    File.open(Rails.root + 'tmp/users.csv', 'w') { |file| file.write(data) }
    File.open(Rails.root + 'tmp/users.csv')
  end
end
