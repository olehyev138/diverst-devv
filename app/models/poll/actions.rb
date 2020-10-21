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
    def base_query(diverst_request)
      "LOWER(#{self.table_name}.title) LIKE :search"
    end

    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then [:fields, :responses]
      when 'show' then [:fields, :responses, :groups, :segments]
      else []
      end
    end
  end
end
