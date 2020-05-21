class Topic < BaseClass
  belongs_to :enterprise
  belongs_to :admin # <== i thought there was no entity called admin??
  has_many :feedbacks, class_name: 'TopicFeedback', dependent: :destroy

  # Returns a list of topics for which nor e1 nor e2 have given feedback for already.
  validates_length_of :statement, maximum: 65535
  def self.unanswered_for_both(e1, e2)
    answered_ids = e1.topic_feedbacks.map(&:topic_id) + e2.topic_feedbacks.map(&:topic_id)
    Topic.where.not(id: answered_ids)
  end
end
