module Sponsors::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end
  module ClassMethods
    def valid_scopes
      ['group_sponsor', 'enterprise_sponsor']
    end
  end
end
