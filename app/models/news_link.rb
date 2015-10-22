class NewsLink < ActiveRecord::Base
  belongs_to :group

  before_validation :smart_add_url_protocol

  protected

  def smart_add_url_protocol
    unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
      self.url = "http://#{self.url}"
    end
  end
end
