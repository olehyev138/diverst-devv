module MentoringSession::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes
      ['creator']
    end

    def valid_scopes
      ['past', 'upcoming', 'ongoing']
    end
  end
end
