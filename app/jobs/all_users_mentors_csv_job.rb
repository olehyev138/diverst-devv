class AllUsersMentorsCsvJob < ActiveJob::Base
  queue_as :default

  def perform(current_id, version: 1)
    enterprise_id = User.find(current_id).enterprise.id
    case version
    when 1
      version1(current_id, enterprise_id)
    when 2
      version2(current_id, enterprise_id)
    else
      raise 'Version Not Defined'
    end
  end

  def version1(current_id, enterprise_id)
    csv_data = CSV.generate do |csv|
      first_row = [
        'All Mentors and Mentees'
      ]

      csv << first_row

      User.where(enterprise_id: enterprise_id).find_each do |user|
        first_user_row = [
          "#{user.name}'s Mentors / Mentees"
        ]

        mentee_start_row = [
          ['', 'Mentees']
        ]

        mentee_rows = mentee_start_row + (user.mentees.map do |mentee|
          ['', '', mentee.name]
        end)

        mentor_start_row = [
          ['', 'Mentors']
        ]

        mentor_rows = mentor_start_row + (user.mentors.map do |mentor|
          ['', '', mentor.name]
        end)

        if mentee_rows.size > 1 || mentor_rows.size > 1
          csv << first_user_row
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
      end
    end

    file = CsvFile.new(user_id: current_id, download_file_name: 'all_mentor(ee)s')

    file.download_file = StringIO.new(csv_data)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, 'all_mentor(ee)s.csv')

    file.save!
  end

  def version2(current_id, enterprise_id)
    csv_data = CSV.generate do |csv|
      first_row = [
        'All Users with their Mentors and Mentees'
      ]

      second_row = %w(User Mentors Mentees)

      csv << first_row
      csv << second_row

      User.where(enterprise_id: enterprise_id).find_each do |user|
        mentor_list = user.mentors.map do |men|
          "#{men.name} | #{men.email}"
        end

        mentee_list = user.mentees.map do |men|
          "#{men.name} | #{men.email}"
        end

        mentors = if mentor_list.present?
          mentor_list.join("\n")
        else
          'None'
        end

        mentees = if mentee_list.present?
          mentee_list.join("\n")
        else
          'None'
        end

        row = [
          "#{user.name} | #{user.email}", mentors, mentees
        ]

        csv << row
      end
    end

    file = CsvFile.new(user_id: current_id, download_file_name: 'all_users_mentors_and_mentees')

    file.download_file = StringIO.new(csv_data)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, 'all_users_mentors_and_mentees.csv')

    file.save!
  end
end
