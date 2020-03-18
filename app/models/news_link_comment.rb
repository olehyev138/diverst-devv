class NewsLinkComment < ApplicationRecord
  belongs_to :author, class_name: 'User', counter_cache: :news_link_comments_count
  belongs_to :news_link

  has_many :user_reward_actions

  validates_length_of :content, maximum: 65535
  validates :author, presence: true
  validates :news_link, presence: true
  validates :content, presence: true

  scope :unapproved, -> { where(approved: false) }
  scope :approved, -> { where(approved: true) }

  def group
    news_link.group
  end
end
