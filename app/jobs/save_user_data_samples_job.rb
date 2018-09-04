# Save a sample of every user

class SaveUserDataSamplesJob < ActiveJob::Base
  queue_as :low

  def perform
    User.find_each do |user|

      sample_data = {
        data: user.data
      }

      if sample = user.samples.where("created_at >= ?", Time.zone.now.beginning_of_day).last
        sample.update(sample_data)
      else
        user.samples.create(sample_data)
      end

    end
  end
end
