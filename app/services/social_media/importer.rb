require 'oembed'
require 'embedly'
require 'json'

class SocialMedia::Importer
  include ApplicationHelper

  MEDIA_MAX_WIDTH = 380

  SMALL_MEDIA_OPTIONS = {
    maxwidth: MEDIA_MAX_WIDTH
  }

  OEmbed::Providers.register_all
  OEmbed::Providers.register_fallback(
      OEmbed::ProviderDiscovery
  )

  if ENV['EMBEDLY_KEY'].blank?
    e = ApplicationHelper::MissingKeyError.new 'EMBEDLY_KEY'
    Rollbar.warn(e)
  end
  @@embedly_api = Embedly::API.new  :key => ENV['EMBEDLY_KEY']

  def self.url_to_embed(url, small: false)
    options = small ? SMALL_MEDIA_OPTIONS : {}

    if matches_url? url
      resource = fetch_oembed_resource(url, options)
    else
      resource = fetch_embedly_resource(url, options)
    end

    unless !!resource
      if matches_url? url
        raise 'Post doesn\'t exist or is private'
      else
        raise 'Site is not supported or URL is not formatted correctly'
      end
    end

    if resource.is_a? String
      resource
    else
      case resource.type
      when 'rich', 'video'
        resource.html
      when 'photo'
        "<img src=\"#{resource.url}\">"
      else
        resource&.html || url
      end
    end
  end

  def self.valid_url?(url)
    set_up_providers
    resource = fetch_resource(url)

    !!resource
  end

  def self.matches_url?(url)
    OEmbed::Providers.find(url)
  end

  def self.oembed_link
    {
      Youtube: %w(https://*.youtube.com/* https://*.youtu.be/*),
      FacebookPost: %w( https://www.facebook.com/*/posts/* https://www.facebook.com/*/activity/* https://www.facebook.com/photo*
                        https://www.facebook.com/photos* https://www.facebook.com/*/photos* https://www.facebook.com/permalink*
                        https://www.facebook.com/media* https://www.facebook.com/questions* https://www.facebook.com/notes*),
      FacebookVideo: %w(https://www.facebook.com/*/videos/* https://www.facebook.com/video*),
      Twitter: [ 'https://*.twitter.com/*/status/*' ],
      Instagram: %w(https://instagr.am/p/* https://instagram.com/p/* https://www.instagram.com/p/*),
      Tumblr: [ 'https://*.tumblr.com/post/*' ],
      Ted: [ 'http://*.ted.com/talks/*' ],
      Vine: [ 'https://*.vine.co/v/*' ],
      Vimeo: [ 'https://*.vimeo.com/*' ],
      Spotify: %w(https://open.spotify.com/* https://play.spotify.com/*),
      Kickstarter: [ 'https://www.kickstarter.com/projects/*' ],
      Imgur: [ 'https://*.imgur.com/gallery/*' ],
      CodePen: [ 'https://codepen.io/*' ],
      Flickr: %w(https://*.flickr.com/* https://flic.kr/*),
      Viddler: [ 'http://*.viddler.com/*' ],
      Qik: %w(http://qik.com/* http://qik.com/video/*),
      Revision3: [ 'http://*.revision3.com/*' ],
      Hulu: [ 'https://www.hulu.com/watch/*' ],
      Slideshare: %w(https://*.slideshare.net/*/* https://*.slideshare.net/mobile/*/*),
      Yfrog: [ 'http://yfrog.com/*' ],
      Giphy: [ 'https://giphy.com/*' ],
      MlgTv: %w(http://tv.majorleaguegaming.com/video/* http://mlg.tv/video/*),
      PollEverywhere: %w( http://www.polleverywhere.com/polls/* http://www.polleverywhere.com/multiple_choice_polls/*
                          http://www.polleverywhere.com/free_text_polls/*),
      MyOpera: [ 'http://my.opera.com/*' ],
      ClearspringWidgets: [ 'http://www.clearspring.com/widgets/*' ],
      NFBCanada: [ 'http://*.nfb.ca/film/*' ],
      Scribd: [ 'http://*.scribd.com/*' ],
      SpeakerDeck: [ 'https://speakerdeck.com/*/*' ],
      MovieClips: [ 'http://movieclips.com/watch/*/*/' ],
      TwentyThree: [ 'http://www.23hq.com/*' ],
      SoundCloud: [ 'https://*.soundcloud.com/*' ],
      Skitch: [ 'https://*.skitch.com/*' ],
    }
  end

  def self.oembed_link_short
    {
        LinkedIn: { links: %w(https://*.linkedin.com/posts/*), icon: 'linkedin_icon.svg' },
        Youtube: { links: %w(https://*.youtube.com/* https://*.youtu.be/*), icon: 'youtube_icon.svg' },
        Facebook: {
            links:
                %w( https://www.facebook.com/*/posts/* https://www.facebook.com/*/activity/* https://www.facebook.com/photo*
                    https://www.facebook.com/photos* https://www.facebook.com/*/photos* https://www.facebook.com/permalink*
                    https://www.facebook.com/media* https://www.facebook.com/questions* https://www.facebook.com/notes*
                    https://www.facebook.com/*/videos/* https://www.facebook.com/video*),
            icon: 'facebook_icon.svg'
        },
        Twitter: { links: [ 'https://*.twitter.com/*/status/*' ], icon: 'twitter_icon.svg' },
        Instagram: {
            links: %w(https://instagr.am/p/* https://instagram.com/p/* https://www.instagram.com/p/*),
            icon: 'instagram_icon.svg'
        },
        Tumblr: { links: [ 'https://*.tumblr.com/post/*' ], icon: 'tumblr_icon.svg' },
        Vimeo: { links: [ 'https://*.vimeo.com/*' ], icon: 'vimeo_icon.svg' },
        SoundCloud: { links: [ 'https://*.soundcloud.com/*' ], icon: 'soundcloud_icon.svg' },
    }
  end

  protected

  def self.fetch_oembed_resource(url, options = {})
    url = url[0...-1] if url[-1] == '/'
    begin
      p 'hello'
      resource = OEmbed::Providers.get(url, options)
    rescue
      nil
    end
  end

  def self.fetch_embedly_resource(url, options = {})
    url = url[0...-1] if url[-1] == '/'
    begin
      p 'goodbye'
      options[:url] = url
      obj = (@@embedly_api.extract options)[0]

      if obj.dig(:error_message).present?
        nil
      else
        "<blockquote class=\"embedly-card\" data-card-key=\"#{ENV['EMBEDLY_KEY']}\" data-card-branding=\"0\" data-card-type=\"article\">
<h4><a href=#{obj.url}>#{obj.title}</a></h4><p>#{obj.description}</p></blockquote>"
      end
    rescue
      nil
    end
  end
end
