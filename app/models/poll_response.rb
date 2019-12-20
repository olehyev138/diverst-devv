class PollResponse < ApplicationRecord
  include PollResponse::Actions
  include ContainsFields

  belongs_to :poll
  belongs_to :user
  has_many :field_data, class_name: 'FieldData', as: :fieldable

  has_many :user_reward_actions, dependent: :destroy

  validates_presence_of :poll
  validates_presence_of :user
  validates_length_of   :data, maximum: 65535

  def fields
    field_holder.fields
  end

  def field_holder
    self.poll
  end

  def field_holder_id
    self.poll_id
  end

  def group
    poll.try(:initiative).try(:group)
  end
end
