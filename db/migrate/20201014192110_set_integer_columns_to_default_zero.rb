class SetIntegerColumnsToDefaultZero < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    change_column :video_rooms, :duration, :integer, default: 0
    change_column :video_rooms, :participants, :integer, default: 0
    change_column :video_participants, :duration, :integer, default: 0
  end
end
