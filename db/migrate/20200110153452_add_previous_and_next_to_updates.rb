class AddPreviousAndNextToUpdates < ActiveRecord::Migration[5.2]
  def up
    add_reference :updates, :previous, index: true
    Update.column_reload!
    UpdateNextAndPreviousUpdateJob.perform_later
  end

  def down
    remove_reference :updates, :previous, index: true
  end
end
