require 'oembed'

class SocialMedia::Importer
  def self.url_to_embed(url)
    return nil unless self.valid_url? url

    register_providers

    resource = fetch_resource(url)

    return nil unless resource

    case resource.type
    when 'rich', 'video'
      resource.html
    when 'photo'
      "<img src='#{resource.url}'>"
    else
      url
    end
  end

  def self.valid_url?(url)
    register_providers
    resource = fetch_resource(url)

    !!resource
  end

  protected

  def self.register_providers
    OEmbed::Providers.register_all
  end

  def self.fetch_resource(url)
    begin
      resource = OEmbed::Providers.get(url)
    rescue
      return nil
    end
  end
end
