class Match < ActiveRecord::Base
  @@status = {
    unswiped: 0,
    accepted: 1, # The person has swiped right and is ready to move on to a conversation
    rejected: 2, # The person has swiped left and doesn't want to try talking to the other
    saved: 3, # After talking for a while, the person decided to opt-in and save the person to his/her contacts
    left: 4 # After talking for a while, the person decided to drop the conversation
  }.freeze

  belongs_to :user1, class_name: "Employee"
  belongs_to :user2, class_name: "Employee"
  belongs_to :topic
  before_create :associate_topic

  accepts_nested_attributes_for :user1, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user2, reject_if: :all_blank, allow_destroy: true

  scope :not_archived, -> { where(archived: false) }
  scope :has_employee, ->(employee) { where('user1_id = ? OR user2_id = ?', employee.id, employee.id) }
  scope :between, ->(employee1, employee2) { has_employee(employee1).has_employee(employee2) }
  scope :active_for, ->(employee) { where('user1_id = ? AND user1_status = ? AND user2_status <> ? OR user2_id = ? AND user2_status = ? AND user1_status <> ?', employee.id, status[:unswiped], status[:rejected], employee.id, status[:unswiped], status[:rejected]) } # An active match is a match that should still be shown in the swipes screen. It hasn't been rejected by anybody and hasn't been swiped yet
  scope :accepted, -> { where('user2_status = ? AND user1_status = ?', @@status[:accepted], @@status[:accepted]) }
  scope :conversations, -> { where('user2_status = ? AND user1_status = ?', @@status[:saved], @@status[:saved]) }
  scope :soon_expired, -> { # Matches that have been created between 1 week and 2 weeks ago
    accepted
    .not_archived
    .where.not(both_accepted_at: nil)
    .where('both_accepted_at < ?', 1.week.ago)
    .where('both_accepted_at > ?', 2.weeks.ago)
  }
  scope :expired, -> { # Matches that have been created more than 2 weeks ago
    accepted
    .not_archived
    .where.not(both_accepted_at: nil)
    .where('both_accepted_at < ?', 2.weeks.ago)
  }

  before_create :update_score

  def update_score
    self.score = self.user1.match_score_with(self.user2)
    self.score_calculated_at = Time.zone.now
  end

  def set_status(employee:, status:)
    if employee.id == self.user1_id
      self.user1_status = status
    elsif employee.id == self.user2_id
      self.user2_status = status
    else
      raise Exception.new("Employee not part of match")
    end
  end

  def set_rating(employee:, rating:)
    if employee.id == self.user1_id
      self.user1_rating = rating
    elsif employee.id == self.user2_id
      self.user2_rating = rating
    else
      raise Exception.new("Employee not part of match")
    end
  end

  def status_for(employee)
    if employee.id == self.user1_id
      self.user1_status
    elsif employee.id == self.user2_id
      self.user2_status
    else
      raise Exception.new("Employee not part of match")
    end
  end

  def rating_for(employee)
    if employee.id == self.user1_id
      self.user1_rating
    elsif employee.id == self.user2_id
      self.user2_rating
    else
      raise Exception.new("Employee not part of match")
    end
  end

  # Returns the other employee
  def other(employee)
    return user2 if user1_id == employee.id
    return user1 if user2_id == employee.id
    raise Exception.new("Employee not part of match")
  end

  def both_accepted?
    user1_status == @@status[:accepted] && user2_status == @@status[:accepted]
  end

  def self.status
    @@status
  end

  def each_user
    [user1, user2].each do |user|
      yield user
    end
  end

  def both_accepted_notification
    return unless conversation_state?
    each_user do |user|
      user.notify("You have been matched with #{other(user).first_name}. Start a conversation now!", { type: "new_match", id: self.id })
    end
  end

  def expires_soon_notification
    each_user do |user|
      user.notify("Your conversation with #{other(user).first_name} will soon expire. Would you like to save him/her?", { type: "match_expires_soon", id: self.id })
    end
  end

  def left_notification
    each_user do |user|
      user.notify("Bummer! #{other(user).first_name} has left the conversation. Meet new people in you organisation here!", { type: "match_left", id: self.id })
    end
  end

  def conversation_state?
    (user1_status == @@status[:accepted] || user1_status == @@status[:saved]) && (user2_status == @@status[:accepted] || user2_status == @@status[:saved])
  end

  # Picks a random topic that hasn't been answered by neither of the match's users
  def associate_topic!
    unanswered_topics = Topic.unanswered_for_both(user1, user2)
    offset = rand(unanswered_topics.count)
    self.topic = unanswered_topics.offset(offset).first
  end
end