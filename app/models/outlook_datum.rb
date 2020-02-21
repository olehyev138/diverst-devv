class OutlookDatum < ActiveRecord::Base
  attr_encrypted :token_hash, key: ENV['OUTLOOK_TOKEN_KEY']

  belongs_to :user
  validates_presence_of :user

  def get_token_hash
    JSON.parse token_hash
  end
end
