class OutlookDatum < ActiveRecord::Base
  attr_encrypted :token_hash, key: ENV['OUTLOOK_TOKEN_KEY']

  belongs_to :user, inverse_of: :outlook_datum
  validates_presence_of :user

  def blank?
    token_hash.blank?
  end

  def outlook_token_hash
    JSON.parse token_hash
  end

  def outlook_token
    OutlookAuthenticator.get_access_token(user)
  end

  def outlook_graph
    OutlookAuthenticator.get_graph(outlook_token)
  end
end
