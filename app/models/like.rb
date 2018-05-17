class Like < ActiveRecord::Base
  belongs_to :news_feed_link
  belongs_to :answer
  belongs_to :enterprise
  belongs_to :user

  validates :enterprise_id, presence: true
  validates :user_id, presence: true

  # Validate to make sure that a maximum of one like object exists for a post/answer, user, and enterprise
  validates :news_feed_link_id, uniqueness: { scope: [:user_id, :enterprise_id] }, if: :has_answer?
  validates :answer_id, uniqueness: { scope: [:user_id, :enterprise_id] },  if: :has_news_feed_link?

  def has_answer?
    :answer.present?
  end

  def has_news_feed_link?
    :news_feed_link.present?
  end
end
