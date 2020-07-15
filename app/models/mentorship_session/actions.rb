module MentorshipSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def accept!
    unless self.update({ status: 'accepted' })
      raise InvalidInputException.new({ message: self.errors.full_messages.first, attribute: self.errors.messages.first.first })
    end
  end

  def decline!
    unless self.update({ status: 'declined' })
      raise InvalidInputException.new({ message: self.errors.full_messages.first, attribute: self.errors.messages.first.first })
    end
  end

  module ClassMethods
    def valid_includes
      ['user', 'mentoring_session']
    end

    def base_preloads
      [:mentoring_session, :user, mentoring_session: MentoringSession.base_preloads, user: User.mentor_lite_includes]
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
