class AddPreviousAndNextToUpdates < ActiveRecord::Migration[5.2]
  # Reordered migration

  def up
    unless column_exists? :updates, :previous_id
      add_reference :updates, :previous, index: true
      Update.column_reload!
      UpdateNextAndPreviousUpdateJob.perform_later
    end
  end

  def down
    remove_reference :updates, :previous, index: true
  end
end
