class MakePrimaryColorRequiredForTheme < ActiveRecord::Migration[5.2]
  def up
    Theme.find_each do |theme|
      theme.primary_color = '7B77C9' unless theme.primary_color.present? # Set to default if it doesn't exist
    end

    change_column_null :themes, :primary_color, false
  end

  def down
    change_column_null :themes, :primary_color, true
  end
end
