module Poll::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes
      [:fields, :responses]
    end
  end
end
