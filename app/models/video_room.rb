class VideoRoom < ActiveRecord::Base
  belongs_to :enterprise
  validates :sid, uniqueness: { scope: :enterprise_id }

  def billing
    if number_of_participants <= 4
      (0.008 * number_of_participants * duration_per_minute).round(4)
    else
      (0.02 * number_of_participants * duration_per_minute).round(4)
    end
  end


  private

  def duration_per_minute
    (((duration || 0)) / 60.0)
  end

  def number_of_participants
    participants || 0
  end
end
