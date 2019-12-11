module ClockworkDatabaseEvent::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:frequency_period]
    end
  end
end
