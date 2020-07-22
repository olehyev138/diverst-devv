module PollResponse::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:poll, :user, :field_data, field_data: FieldData.base_preloads]
    end
  end
end
