module Sponsor::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end
  module ClassMethods
    def valid_scopes
      ['group_sponsor', 'enterprise_sponsor']
    end

    def base_preloads(diverst_action)
      [:sponsor_media_attachment, :sponsor_media_blob, :sponsorable]
    end

    def base_attributes_preloads
      [ :sponsor_media_attachment, :sponsor_media_blob ]
    end
  end
end
