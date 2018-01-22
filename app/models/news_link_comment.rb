class NewsLinkComment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :news_link

  validates :author, presence: true
  validates :news_link, presence: true
  validates :content, presence: true
  
  scope :unapproved, -> {where(:approved => false)}

  def group
    news_link.group
  end
end
