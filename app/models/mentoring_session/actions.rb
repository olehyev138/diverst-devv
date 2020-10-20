module MentoringSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then [:creator]
      when 'show' then [:creator, :users, :mentoring_interests, creator: User.mentor_includes, users: User.mentor_lite_includes]
      else []
      end
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
