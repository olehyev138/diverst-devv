class ReformatGroupColorHash < ActiveRecord::Migration[5.2]
  def change
    Group.find_each do |g|
      g.calendar_color = g.calendar_color.presence&.gsub('#', '')
      unless g.save
        g.update(calendar_color: nil)
      end
    end
  end
end
