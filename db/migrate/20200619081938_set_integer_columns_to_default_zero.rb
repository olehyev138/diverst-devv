class SetIntegerColumnsToDefaultZero < ActiveRecord::Migration
  def change
    change_column :video_rooms, :duration, :integer, default: 0
    change_column :video_rooms, :participants, :integer, default: 0
    change_column :video_participants, :duration, :integer, default: 0
  end
end
