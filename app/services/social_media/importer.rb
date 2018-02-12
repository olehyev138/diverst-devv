require 'oembed'

class SocialMedia::Importer
  MEDIA_MAX_WIDTH=380

  DEFAULT_MEDIA_OPTIONS={
    maxwidth: MEDIA_MAX_WIDTH
  }

  def self.url_to_embed(url)
    return nil unless self.valid_url? url

    set_up_providers

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
    set_up_providers
    resource = fetch_resource(url)

    !!resource
  end

  protected

  def self.set_up_providers
    unless @key_registered
      embedly_key = ENV['EMBEDLY_KEY']
      OEmbed::Providers::Embedly.endpoint += "?key=#{embedly_key}"
      @key_registered = true
    end

    OEmbed::Providers.register OEmbed::Providers::Embedly, OEmbed::Providers::Noembed
  end

  def self.fetch_resource(url, options={})
    begin
      resource = OEmbed::Providers.get(url, DEFAULT_MEDIA_OPTIONS.merge(options) )
    rescue
      return nil
    end
  end
end
