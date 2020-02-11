class Importers::Users
  DEFAULT_COLUMN_DELIMITER = ','

  attr_reader :table, :failed_rows, :successful_rows

  def initialize(file, manager)
    @table = CSV.read file, col_sep: get_delimiter, encoding: 'ISO-8859-1', headers: true, header_converters: lambda { |h|
      h.split.join(' ').downcase
    }
    @manager = manager
    @enterprise = manager.enterprise

    @failed_rows = []
    @successful_rows = []
  end

  def import
    @table.each_with_index do |row, row_index|
      user = parse_from_csv_row(row)
      new_user = user.new_record? ? true : false
      if user.save
        if new_user
          user.invite!(@manager) do |u|
            u.skip_invitation = !@manager.enterprise.has_enabled_onboarding_email
          end
        end

        @successful_rows << row
      else
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: user.errors.full_messages.join(', ')
        }
      end
    end
  end

  private

  def parse_from_csv_row(row)
    user = update_user(row) || initialize_user(row)
    user.field_data.load
    field_data_attributes = []
    (0..row.length - 1).each do |i|
      field = @enterprise.fields.find_by('LOWER(title) = ?', row.headers[i])
      next if field.blank?

      data = user.field_data.find { |fd| fd.field_id == field.id }
      next if data.blank?

      field_data_attributes.append({
                                       id: data.id,
                                       data: data.data
                                   })
    end
    user.attributes[field_data_attributes] = field_data_attributes
    join_groups(user, row)
    user
  end

  def join_groups(user, row)
    user.enterprise.groups.where(name: row['Group Membership'].split(',').map(&:strip)).find_each do |group|
      unless user.user_groups.where(group_id: group.id).any?
        user.user_groups.build(group_id: group.id)
      end
    end
  end

  def update_user(row)
    user = User.where(email: row['email']).first
    return nil unless user

    user.attributes = user_attributes(row, user)
    user
  end

  def initialize_user(row)
    @enterprise.users.new user_attributes(row, nil)
  end

  def user_attributes(row, user)
    id = user.present? ? user.user_role_id : @enterprise.default_user_role # default_user_role returns the ID of the default role

    {
      first_name: row['first name'],
      last_name: row['last name'],
      email: row['email'],
      biography: (row['biography'].present?) ? row['biography'] : user&.biography,
      active: process_active_column(row['active']),
      user_role_id: id,
      password: Faker::String.random(12),
    }
  end

  def process_active_column(column_value)
    truthy_values = [1, '1', true, 'true', 'TRUE', 'yes', 'YES', '', nil]

    truthy_values.include? column_value
  end

  def get_delimiter
    custom_delimiter = ENV['CSV_COLUMN_SEPARATOR']
    custom_delimiter.presence || DEFAULT_COLUMN_DELIMITER
  end
end
