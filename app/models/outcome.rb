class Outcome < ActiveRecord::Base
  belongs_to :enterprise
  has_many :pillars
end
