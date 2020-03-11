class RedoAvailibilityTable1 < ActiveRecord::Migration[5.1]
  def up
    add_column :mentorship_availabilities, :day2, :integer, null: false, default: 1
    add_column :mentorship_availabilities, :start2, :time, null: false
    add_column :mentorship_availabilities, :end2, :time, null: false
  end

  def down
    MentorshipAvailability.column_reload!
    map = MentorshipAvailability.all.map {|a| {id: a.id, day: a.day, start: a.start, end: a.end}}

    MentorshipAvailability.all.each do |ma|
      old = map.find {|m| m[:id] == ma.id}
      ma.day2 = TimeHelper.i_to_weekday(old[:day])

      ma.start2 = TimeHelper.time_to_s(old[:start].to_i)
      ma.end2 = TimeHelper.time_to_s(old[:end].to_i)
      ma.save!
    end

    remove_column :mentorship_availabilities, :day, :string
    remove_column :mentorship_availabilities, :start, :string
    remove_column :mentorship_availabilities, :end, :string

    rename_column :mentorship_availabilities, :day2, :day
    rename_column :mentorship_availabilities, :start2, :start
    rename_column :mentorship_availabilities, :end2, :end
  end
end
