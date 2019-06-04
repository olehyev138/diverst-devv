class AddCalendarColorToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :calendar_color, :string
  end
end
