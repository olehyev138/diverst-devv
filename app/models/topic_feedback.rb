class TopicFeedback < ApplicationRecord
  belongs_to :topic
  belongs_to :user
  validates_length_of :content, maximum: 65535
end
