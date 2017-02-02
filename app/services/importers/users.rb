class Importers::Users
  attr_reader :table, :failed_rows, :successful_rows

  def initialize(file, manager)
    @table = CSV.table file
    @manager = manager
    @enterprise = manager.enterprise

    @failed_rows = []
    @successful_rows = []
  end

  def import
    @table.each_with_index do |row, row_index|
      user = from_csv_row(row)

      if user
        if user.save
          user.invite!(@manager)
          @successful_rows << row
        else
          # ActiveRecord validation failed on user
          @failed_rows << {
            row: row,
            row_index: row_index + 1,
            error: user.errors.full_messages.join(', ')
          }
        end
      else
        # User.from_csv_row returned nil
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: 'Missing required information'
        }
      end
    end
  end

  private
  def from_csv_row(row)
    return nil if row[0].nil? || row[1].nil? || row[2].nil? # Require first_name, last_name and email

    user = User.new(
      first_name: row[0],
      last_name: row[1],
      email: row[2],
      enterprise: @enterprise
    )

    @enterprise.fields.each_with_index do |field, i|
      user.info[field] = field.process_field_value row[3 + i]
    end

    user
  end
end
