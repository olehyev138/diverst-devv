class AddJobStatusToSegment < ActiveRecord::Migration
  def up
    add_column :segments, :job_status, :integer, default: 0, null: false

    execute "UPDATE `segments` SET `job_status` = 0;"
  end

  def down
    remove_column :segments, :job_status
  end
end
