class NewsLinkComment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :news_link
  
  has_many :user_reward_actions
  
  validates :author, presence: true
  validates :news_link, presence: true
  validates :content, presence: true

  scope :unapproved, -> {where(:approved => false)}
  scope :approved, ->{ where(:approved => true) }

  def group
    news_link.group
  end
end
