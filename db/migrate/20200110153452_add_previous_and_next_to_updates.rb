class AddPreviousAndNextToUpdates < ActiveRecord::Migration[5.2]
  def up
    add_reference :updates, :previous, index: true
    Update.connection.schema_cache.clear!
    Update.reset_column_information
    UpdateNextAndPreviousUpdateJob.perform_later
  end

  def down
    remove_reference :updates, :previous, index: true
  end
end
