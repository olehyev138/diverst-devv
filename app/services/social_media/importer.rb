require 'oembed'

class SocialMedia::Importer
  MEDIA_MAX_WIDTH = 380

  DEFAULT_MEDIA_OPTIONS = {
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
      PollEverywhere: %w(http://www.polleverywhere.com/polls/* http://www.polleverywhere.com/multiple_choice_polls/* http://www.polleverywhere.com/free_text_polls/*),
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
    resource = OEmbed::Providers.get(url, DEFAULT_MEDIA_OPTIONS.merge(options))
  rescue
    nil
  end
end
