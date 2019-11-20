module MentorshipSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:mentoring_session, mentoring_session: MentoringSession.base_preloads]
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
