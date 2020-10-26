module Folder::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def validate_password(diverst_request, params)
      # check for an id and password
      raise BadRequestException.new 'Folder ID and password required' unless params[:id].present? && params[:password].present?

      id = params[:id]
      password = params[:password]

      # find the folder
      folder = find_by(id: id)
      raise BadRequestException.new 'Folder does not exist' if folder.nil?

      # verify the password
      unless folder.valid_password?(password)
        raise BadRequestException.new 'Incorrect password'
      end

      folder
    end

    def base_query(diverst_request)
      "LOWER(#{self.table_name}.name) LIKE :search"
    end

    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then []
      when 'show' then [:parent]
      else []
      end
    end
  end
end
