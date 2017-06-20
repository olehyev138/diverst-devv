class SocialLink < ActiveRecord::Base
  self.table_name = 'social_network_posts'

  validate :correct_url?

  before_create :populate_embed_code

  belongs_to :author, class_name: 'User'


  protected

  def correct_url?
    SocialMedia::Importer.valid_url? url
  end

  def populate_embed_code
    self.embed_code = SocialMedia::Importer.url_to_embed url
  end
end
