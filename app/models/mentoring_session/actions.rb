module MentoringSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:creator, :users, :mentoring_interests, creator: User.mentor_includes, users: User.mentor_lite_includes]
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
