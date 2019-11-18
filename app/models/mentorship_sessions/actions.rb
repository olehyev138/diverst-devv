module MentorshipSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes
      ['mentoring_sessions', mentoring_sessions: MentoringSession.base_includes]
    end

    def base_joins
      ['mentoring_sessions']
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
