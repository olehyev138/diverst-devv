class Session < ApplicationRecord
  # associations
  belongs_to :user

  # validations
  validates_presence_of   :token,             message: 'Value Required'
  validates_presence_of   :expires_at,        message: 'Value Required'
  validates_presence_of   :user,              message: 'Value Required'

  enum status: {
    active: 0,
    inactive: 1
  }, _prefix: :status

  def self.query_arguments
    ['user_id']
  end

  def self.query_arguments_hash(query, value)
    case query
    when 'user_id'
      { user_id: value }
    end
  end
end
