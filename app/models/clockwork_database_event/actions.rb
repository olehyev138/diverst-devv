module ClockworkDatabaseEvent::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads(diverst_request) ##
      [:frequency_period]
    end
  end
end
