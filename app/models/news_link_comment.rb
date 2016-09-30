class NewsLinkComment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :news_link
end
