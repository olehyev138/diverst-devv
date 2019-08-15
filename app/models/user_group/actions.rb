require 'securerandom'

module UserGroup::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_joins
      [ :user, :group ]
    end
  end
end
