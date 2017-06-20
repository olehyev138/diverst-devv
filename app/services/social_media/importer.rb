require 'oembed'

class SocialMedia::Importer
  def self.url_to_embed(url)
    return nil unless self.valid_url? url

    OEmbed::Providers.register_all
    resource = OEmbed::Providers.get(url)

    resource.html
  end

  def self.valid_url?(url)
    OEmbed::Providers.find(url).present?
  end
end
