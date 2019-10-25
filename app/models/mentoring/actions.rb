module Mentoring::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_joins
      [ :mentor, :mentee ]
    end
  end
end
