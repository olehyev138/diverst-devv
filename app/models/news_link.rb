class NewsLink < ActiveRecord::Base
  belongs_to :group

  before_validation :smart_add_url_protocol

  protected

  def smart_add_url_protocol
    self.url = "http://#{url}" unless url[%r{\Ahttp:\/\/}] || url[%r{\Ahttps:\/\/}]
  end
end
