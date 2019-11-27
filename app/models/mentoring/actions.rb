module Mentoring::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_includes
      ['mentee', 'mentor']
    end
  end
end
