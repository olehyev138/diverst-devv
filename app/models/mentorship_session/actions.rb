module MentorshipSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def accept
    unless self.update_attributes({ status: 'accepted' })
      raise InvalidInputException.new({ message: self.errors.full_messages.first, attribute: item.errors.messages.first.first })
    end
  end

  def decline
    unless self.update_attributes({ status: 'declined' })
      raise InvalidInputException.new({ message: self.errors.full_messages.first, attribute: item.errors.messages.first.first })
    end
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
