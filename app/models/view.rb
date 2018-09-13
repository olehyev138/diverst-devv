class View < ActiveRecord::Base
  belongs_to :news_feed_link
  belongs_to :group
  belongs_to :user
  belongs_to :enterprise
  belongs_to :resource
  belongs_to :folder
end
