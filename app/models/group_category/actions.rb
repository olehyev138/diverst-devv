module GroupCategory::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes(diverst_request) ##
      [ :group, :group_category ]
    end
  end
end
