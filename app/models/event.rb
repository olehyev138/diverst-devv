class Event < ActiveRecord::Base
  has_and_belongs_to_many :segments
  belongs_to :group

  scope :past, -> { where('end < ?', DateTime.now).order(start: :desc) }
  scope :upcoming, -> { where('start > ?', DateTime.now).order(start: :desc) }
  scope :ongoing, -> { where('start <= ?', DateTime.now).where('end >= ?', DateTime.now).order(start: :desc) }

  def time_string
    if self.start.to_date === self.end.to_date # If the event starts and ends on the same day
      "#{self.start.to_s :dateonly} from #{self.start.to_s :ampmtime} to #{self.end.to_s :ampmtime}"
    else
      "From #{self.start.to_s :datetime} to #{self.end.to_s :datetime}"
    end
  end
end
