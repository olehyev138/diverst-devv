class FixEmailVariables < ActiveRecord::Migration[5.2]
  def up
    EmailVariablesService.update_email_variables unless Rails.env.test?
  end

  def down
  end
end
