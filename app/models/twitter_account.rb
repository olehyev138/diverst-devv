class TwitterAccount < ActiveRecord::Base

  # validates_uniqueness_of :account, scope: :group_id
  # validates_uniqueness_of :name, scope: :group_id
  validates :name, presence: true, uniqueness: { scope: :group_id, :case_sensitive => false }
  validates :account, presence: true, uniqueness: { scope: :group_id, :case_sensitive => false }
  validate :user_exists, :if => -> {account.present?}

  private

  def user_exists
    client = TwitterClient.client
    begin
      client.user(account)
      return nil
    rescue Twitter::Error::NotFound
      errors.add(:account, 'User doesn\'t exists')
    end
  end

end