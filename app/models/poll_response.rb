class PollResponse < BaseClass
  include ContainsFields

  belongs_to :poll
  belongs_to :user

  has_many :user_reward_actions, dependent: :destroy

  after_create :send_poll_response_notification

  validates_length_of :data, maximum: 65535

  def group
    poll&.initiative&.group
  end

  private

  def send_poll_response_notification
    PollResponseNotifierJob.perform_later(self.id)
  end
end
