class UserMentorsCsvJob < ActiveJob::Base
  queue_as :default

  def perform(current_id, user_id)
    user = User.find(user_id)
    csv_data = CSV.generate do |csv|
      first_row = [
        "#{user.name}'s Mentors / Mentees"
      ]

      mentee_start_row = [
        ['Mentees']
      ]

      mentee_rows = mentee_start_row + (user.mentees.map do |mentee|
        ['', mentee.name]
      end)

      mentor_start_row = [
        ['Mentors']
      ]

      mentor_rows = mentor_start_row + (user.mentors.map do |mentor|
        ['', mentor.name]
      end)

      csv << first_row

      if mentee_rows.size > 1
        mentee_rows.each do |row|
          csv << row
        end
      end

      if mentor_rows.size > 1
        mentor_rows.each do |row|
          csv << row
        end
      end
    end

    file = CsvFile.new(user_id: current_id, download_file_name: "#{user.name}_mentor(ee)s")

    file.download_file = StringIO.new(csv_data)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "#{user.name}_mentor(ee)s.csv")

    file.save!
  end
end
