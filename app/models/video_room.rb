class VideoRoom < ActiveRecord::Base
  belongs_to :enterprise
  validates :sid, uniqueness: { scope: :enterprise_id }
end
