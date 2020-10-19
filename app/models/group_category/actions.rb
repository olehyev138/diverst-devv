module GroupCategory::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes(diverst_request) ##
      [ :group ]
    end
  end
end
