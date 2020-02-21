class OutlookDatum < ActiveRecord::Base
  attr_encrypted :token_hash, key: ENV['OUTLOOK_TOKEN_KEY']

  belongs_to :user, inverse_of: :outlook_datum
  validates_presence_of :user

  def blank?
    token_hash.blank?
  end

  def get_token_hash
    JSON.parse token_hash
  end
end
