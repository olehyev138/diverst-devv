module MentoringSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then [:creator]
      when 'show' then [:creator, :users, :mentoring_interests]
      else []
      end
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
