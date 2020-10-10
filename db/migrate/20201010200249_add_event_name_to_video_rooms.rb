class AddEventNameToVideoRooms < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :video_rooms, :event_name
      add_column :annual_budgets, :event_name, :datetime
    end
  end
end
