class AddCalendarColorToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :calendar_color, :string
  end
end
