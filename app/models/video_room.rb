class VideoRoom < ActiveRecord::Base
  SMALL_GROUP_PRICING = 0.01
  LARGE_GROUP_PRICING = 0.02
  belongs_to :enterprise
  has_many :video_participants, dependent: :destroy
  validates :sid, uniqueness: { scope: :enterprise_id }

  def billing
    if number_of_participants <= 4
      (SMALL_GROUP_PRICING * cumulative_participant_minutes).round(4)
    else
      (LARGE_GROUP_PRICING * cumulative_participant_minutes).round(4)
    end
  end

  def cumulative_participant_minutes
    video_participants.sum(:duration)
  end

  def duration_per_minute
    m, s = [duration / 60, duration % 60]
    "#{m} min #{s} sec"
  end

  def number_of_participants
    video_participants.pluck(:identity).uniq.count
  end

  def start_time
    start_date&.strftime('%a, %d %b %Y %H:%M %p')
  end

  def end_time
    end_date&.strftime('%a, %d %b %Y %H:%M %p')
  end

  def event_name
    Initiative.find_by(id: initiative_id)&.name
  end
end
