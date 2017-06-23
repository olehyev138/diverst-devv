class SocialLink < ActiveRecord::Base
  self.table_name = 'social_network_posts'

  validate :correct_url?

  before_create :populate_embed_code

  belongs_to :author, class_name: 'User', required: true


  protected

  def correct_url?
    unless SocialMedia::Importer.valid_url? url
      errors.add(:url, "is not a valid url for supported services")
    end
  end

  def populate_embed_code
    self.embed_code = SocialMedia::Importer.url_to_embed url
  end
end
