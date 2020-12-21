class Session < ApplicationRecord
  include Session::Actions

  # associations
  belongs_to :user

  # validations
  validates_presence_of   :token,             message: I18n.t('errors.session.value_required')
  validates_presence_of   :expires_at,        message: I18n.t('errors.session.value_required')
  validates_presence_of   :user,              message: I18n.t('errors.session.value_required')

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
