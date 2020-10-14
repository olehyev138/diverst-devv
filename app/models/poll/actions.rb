module Poll::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def publish!
    update(status: 'published')
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.title) LIKE :search"
    end

    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then []
      when 'show' then [:fields, :groups, :segments, :enterprise]
      else []
      end
    end
  end
end
