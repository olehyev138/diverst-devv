class VideoRoom < ActiveRecord::Base
  belongs_to :enterprise
  has_many :video_participants, dependent: :destroy
  validates :sid, uniqueness: { scope: :enterprise_id }

  def billing
    if number_of_participants <= 4
      (0.01 * cumulative_participant_minutes).round(4)
    else
      (0.02 * cumulative_participant_minutes).round(4)
    end
  end

  def cumulative_participant_minutes
    video_participants.sum(:duration)
  end

  def duration_per_minute
    (((duration || 0)) / 60.0)
  end

  def number_of_participants
    participants || 0
  end

  def event_name
    Initiative.find_by(id: initiative_id)&.name
  end
end
