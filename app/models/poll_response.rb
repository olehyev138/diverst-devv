class PollResponse < BaseClass
  include ContainsFields

  belongs_to :poll
  belongs_to :user

  has_many :user_reward_actions, dependent: :destroy

  after_commit :send_poll_response_notification, on: :create

  validates_length_of :data, maximum: 65535

  def group
    poll&.initiative&.group
  end

  def user_email
    puts 'hello world'
    return 'Anonymous' if anonymous

    user.notifications_email
  end

  def user_name
    return 'Anonymous' if anonymous

    user.name
  end

  def user_id 
    return 'Anonymous' if anonymous

    user.id
  end

  private

  def send_poll_response_notification
    PollResponseNotifierJob.perform_later(self.id)
  end
end
