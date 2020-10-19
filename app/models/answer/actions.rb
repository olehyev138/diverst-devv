module Answer::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_includes(diverst_request) ##
      [ :author ]
    end

    def base_preloads(diverst_request)
      if diverst_request.action == 'show'
        [ :question, :likes, :comments, comments: [ :author ] ]
      else
        [ :question, :likes ]
      end
    end
  end
end
