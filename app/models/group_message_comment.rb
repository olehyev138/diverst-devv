class GroupMessageComment < ApplicationRecord
  include GroupMessageComment::Actions

  belongs_to :author, class_name: 'User', counter_cache: :message_comments_count
  belongs_to :message, class_name: 'GroupMessage'
  has_one :news_feed_link, through: :message

  has_many :user_reward_actions

  validates_length_of :content, maximum: 65535
  validates :author, presence: true
  validates :message, presence: true
  validates :content, presence: true

  scope :unapproved, -> { where(approved: false) }
  scope :approved, -> { where(approved: true) }

  def group
    message.group
  end
end
