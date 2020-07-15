module MentoringRequest::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def accept(diverst_request)
    if self.update_attributes({ status: 'accepted' })
      mentor_id = mentoring_type == 'mentor' ? receiver_id : sender_id
      mentee_id = mentoring_type == 'mentor' ? sender_id : receiver_id

      Mentoring.build(diverst_request, {
        mentoring: {
          mentor_id: mentor_id,
          mentee_id: mentee_id
        }
      })
      notify_accepted_request
      self
    else
      raise InvalidInputException.new({ message: self.errors.full_messages.first, attribute: item.errors.messages.first.first })
    end
  end

  def reject
    if self.update_attributes({ status: 'rejected' })
      notify_declined_request
      self
    else
      raise InvalidInputException.new({ message: self.errors.full_messages.first, attribute: item.errors.messages.first.first })
    end
  end

  module ClassMethods
    def valid_includes
      ['sender', 'receiver']
    end

    def valid_scopes
      ['pending', 'accepted', 'rejected']
    end
  end
end
