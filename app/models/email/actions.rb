module Email::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request)
      [:email_variables, :variables]
    end
  end
end
