class NewsLinkSerializer < ApplicationRecordSerializer
  has_one   :group
  has_one   :author
  has_one   :news_feed_link
  has_many  :photos
end
