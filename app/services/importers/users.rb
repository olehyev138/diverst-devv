class Importers::Users
  attr_reader :table, :failed_rows, :successful_rows

  def initialize(file, manager)
    @table = CSV.read file, headers: true, header_converters: lambda { |h|
      h.split.join(" ").downcase
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
        user.invite!(@manager) if new_user
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
    (0..row.length-1).each do |i|
      field = @enterprise.fields.where("LOWER(title) = ?", row.headers[i]).first
      user.info[field] = field.process_field_value row[i] if field && !row[i].blank?
    end
    user
  end

  def update_user(row)
    user = User.where(email: row["email"]).first
    return nil unless user
    user.attributes = user_attributes(row)
    user
  end

  def initialize_user(row)
    @enterprise.users.new user_attributes(row)
  end

  def user_attributes(row)
    { first_name: row["first name"], last_name: row["last name"], email: row["email"] }
  end
end
