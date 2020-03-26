module InitiativeUser::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def csv_attributes(current_user = nil, params = {})
      {
          titles: ['First name',
                   'Last name',
                   'Email',
                   'Attended',
                   'Checked In',
                   'Check In Time',
          ],
          values: [
              'user.first_name',
              'user.last_name',
              'user.email',
              'attended',
              'check_in_time.present?',
              'check_in_time',
          ]
      }
    end

    def file_name(params)
      initiative = params[:initiative_id].present? ? Initiative.find(params[:initiative_id]) : nil
      raise ArgumentError.new('Valid event id needs to be given') if initiative.blank?

      parts = ["Attendees of #{initiative.name}"]

      file_name = parts.map { |part| part.split(/[ .]/).join('_') }.join('_')
      ActiveStorage::Filename.new(file_name).sanitized
    end
  end
end

