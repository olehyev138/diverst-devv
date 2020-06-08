class VideoParticipant < ActiveRecord::Base
  belongs_to :video_room

  def duration_per_minute
    m, s = [duration / 60, duration % 60]
    if m > 0
      "#{m} min #{s} sec"
    else
      "#{s} sec"
    end
  end
end
