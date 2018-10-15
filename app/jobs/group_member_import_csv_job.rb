class GroupMemberImportCSVJob < ActiveJob::Base
  queue_as :low

  def perform(file_id)
    file = CsvFile.find_by_id(file_id)
    return false unless file.present?
    
    group = file.group
    return if group.nil?

    table = CSV.table file.path_for_csv
    
    failed_rows = []
    successful_rows = []

    table.each_with_index do |row, row_index|
        email = row[0]
        user = User.where(email: email).first
        if user
            group.members << user unless group.members.include? user

            successful_rows << row
        else
            failed_rows << {
                row: row,
                row_index: row_index + 1,
                error: 'There is no user with this email address in the database'
            }
        end
    end

    group.save
    
    CsvUploadMailer.result(successful_rows, failed_rows, table.count).deliver_now
  end
end