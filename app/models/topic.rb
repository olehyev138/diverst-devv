class Topic < ActiveRecord::Base
  belongs_to :enterprise
  belongs_to :admin
end
