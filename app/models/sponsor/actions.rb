module Sponsor::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end
  module ClassMethods
    def valid_scopes
      ['group_sponsor', 'enterprise_sponsor']
    end

    def base_attributes_preloads
      [ :sponsor_media_attachment ]
    end
  end
end
