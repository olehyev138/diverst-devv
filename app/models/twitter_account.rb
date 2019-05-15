class TwitterAccount < ActiveRecord::Base
  belongs_to :group

  validates :name, presence: true, uniqueness: { scope: :group_id, case_sensitive: false }
  validates :account, presence: true, uniqueness: { scope: :group_id, case_sensitive: false }
  validate :user_exists, if: -> { account.present? }
  validates :group_id, presence: true

  private

  def user_exists
    client = TwitterClient.client
    begin
      client.user(account)
      return nil
    rescue Twitter::Error::NotFound
      errors.add(:account, 'User doesn\'t exist')
    end
  end
end
