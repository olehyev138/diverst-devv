require 'oembed'

class SocialMedia::Importer
  MEDIA_MAX_WIDTH = 380

  SMALL_MEDIA_OPTIONS = {
    maxwidth: MEDIA_MAX_WIDTH
  }

  def self.url_to_embed(url, small: false)
    set_up_providers
    options = small ? SMALL_MEDIA_OPTIONS : {}
    resource = fetch_resource(url, options)

    unless !!resource
      if matches_url? url
        raise 'Post doesn\'t exist or is private'
      else
        raise 'Site is not supported or URL is not formatted correctly'
      end
    end

    case resource.type
    when 'rich', 'video'
      resource.html
    when 'photo'
      '<img src="#{resource.url}">'
    else
      resource&.html || url
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
        Imgur: { links: [ 'https://*.imgur.com/gallery/*' ], icon: 'imgur_icon.svg' },
        SoundCloud: { links: [ 'https://*.soundcloud.com/*' ], icon: 'soundcloud_icon.svg' },
    }
  end

  protected

  def self.set_up_providers
    OEmbed::Providers.register_all
    OEmbed::Providers.register_fallback(
      OEmbed::ProviderDiscovery,
      OEmbed::Providers::Noembed
    )
  end

  def self.fetch_resource(url, options = {})
    url = url[0...-1] if url[-1] == '/'
    resource = OEmbed::Providers.get(url, options)
  rescue
    nil
  end
end
