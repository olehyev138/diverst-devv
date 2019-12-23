class PollResponse < ApplicationRecord
  @@fields_holder_name = 'poll'
  include PollResponse::Actions
  include ContainsFieldData

  belongs_to :poll
  belongs_to :user
  has_many :field_data, class_name: 'FieldData', as: :fieldable, dependent: :destroy

  has_many :user_reward_actions, dependent: :destroy

  validates_presence_of :poll
  validates_presence_of :user
  validates_length_of   :data, maximum: 65535

  def self.fields_holder_name
    @@fields_holder_name
  end

  def group
    poll.try(:initiative).try(:group)
  end
end
