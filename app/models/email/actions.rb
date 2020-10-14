module Email::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then []
      when 'show' then [:email_variables, :variables]
      else []
      end
    end
  end
end
