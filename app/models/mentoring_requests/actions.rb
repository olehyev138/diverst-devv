module MentoringRequest::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_includes
      ['sender', 'reciever']
    end
  end
end
