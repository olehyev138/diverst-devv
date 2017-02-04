class Importers::Users
  attr_reader :table, :failed_rows, :successful_rows

  def initialize(file, manager)
    @table = CSV.read file, headers: true
    @manager = manager
    @enterprise = manager.enterprise

    @failed_rows = []
    @successful_rows = []
  end

  def import
    @table.each_with_index do |row, row_index|
      user = parse_from_csv_row(row)
      if user.new_record? && user.save
        user.invite!(@manager)
        @successful_rows << row
      elsif user.save
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
      field = Field.where(title: row.headers[i]).first
      user.info[field] = field.process_field_value row[i] if field && !row[i].blank?
    end
    user
  end

  def update_user(row)
    user = User.where(email: row["Email"]).first
    return nil unless user

    user.attributes = { first_name: row["First name"], last_name: row["Last name"] }
    user
  end

  def initialize_user(row)
    User.new(
      first_name: row["First name"],
      last_name: row["Last name"],
      email: row["Email"],
      enterprise: @enterprise
    )
  end
end
