class RedoAvailibilityTable2 < ActiveRecord::Migration[5.1]
  def up
    MentorshipAvailability.column_reload!
    map = MentorshipAvailability.all.map {|a| {id: a.id, day: a.day, start: a.start, end: a.end}}
    MentorshipAvailability.all.each do |ma|
      old = map.find {|m| m[:id] == ma.id}
      ma.day2 = TimeHelper.weekday_to_i(old[:day])

      ma.start2 = Time.at(TimeHelper.s_to_time(old[:start]))
      ma.end2 = Time.at(TimeHelper.s_to_time(old[:end]))
      ma.save!
    end

    remove_column :mentorship_availabilities, :day, :string
    remove_column :mentorship_availabilities, :start, :string
    remove_column :mentorship_availabilities, :end, :string

    rename_column :mentorship_availabilities, :day2, :day
    rename_column :mentorship_availabilities, :start2, :start
    rename_column :mentorship_availabilities, :end2, :end
  end

  def down
    add_column :mentorship_availabilities, :day2, :string, null: false, default: 'Monday'
    add_column :mentorship_availabilities, :start2, :string, null: false
    add_column :mentorship_availabilities, :end2, :string, null: false
  end
end
