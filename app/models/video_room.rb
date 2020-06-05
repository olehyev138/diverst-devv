class VideoRoom < ActiveRecord::Base
  require 'twilio-ruby'

  belongs_to :enterprise
  validates :sid, uniqueness: { scope: :enterprise_id }

  def billing
    if number_of_participants <= 4
      (0.01 * cumulative_participant_minutes).round(4)
    else
      (0.02 * cumulative_participant_minutes).round(4)
    end
  end

  def cumulative_participant_minutes
    raise BadRequestException.new 'TWILIO_ACCOUNT_SID Required' if ENV['TWILIO_ACCOUNT_SID'].blank?
    raise BadRequestException.new 'TWILIO_AUTH_TOKEN Required' if ENV['TWILIO_AUTH_TOKEN'].blank?

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    client.video.rooms(sid).participants.list.map(&:duration).inject(0) { |x, y| x + y }
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
