class PollResponse < ApplicationRecord
  @@field_definer_name = 'poll'
  @@field_association_name = 'fields'
  mattr_reader :field_association_name, :field_definer_name

  include PollResponse::Actions
  include ContainsFieldData

  belongs_to :poll
  belongs_to :user
  has_many :field_data, class_name: 'FieldData', as: :field_user, dependent: :destroy

  has_many :user_reward_actions, dependent: :destroy

  validates_length_of :data, maximum: 65535

  def group
    poll&.initiative&.group
  end
end
