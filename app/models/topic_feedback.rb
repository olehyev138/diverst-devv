class TopicFeedback < ActiveRecord::Base
  belongs_to :topic
  belongs_to :employee
end
