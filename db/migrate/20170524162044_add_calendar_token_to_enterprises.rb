class AddCalendarTokenToEnterprises < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.string :iframe_calendar_token
    end
  end
end
