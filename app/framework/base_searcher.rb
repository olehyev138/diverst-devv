module BaseSearcher
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "#{self.table_name}.id LIKE :search"
    end

    def valid_scopes
      []
    end

    def excluded_scopes
      [:destroy_all, :delete_all, 'destroy_all', 'delete_all']
    end

    def valid_includes
      []
    end

    def base_preloads
      []
    end

    def preload_attachments
      []
    end

    def set_query_scopes(params)
      if params[:query_scopes].presence
        case params[:query_scopes].class.name
        when 'Array'
          scopes = params[:query_scopes]
        when 'String'
          scopes = JSON.parse(params[:query_scopes])
        else
          scopes = []
        end

        filtered = scopes - excluded_scopes

        filtered.select { |query_scope|
          if query_scope.kind_of?(String) || query_scope.kind_of?(Symbol)
            valid_scopes.include?(query_scope)
          elsif query_scope.kind_of?(Array)
            valid_scopes.include?(query_scope.first)
          end
        }
      else
        [:all]
      end
    end

    def set_includes(params)
      if params[:includes].present?
        case params[:includes].class.name
        when 'Array'
          includes = params[:includes]
        when 'String'
          includes = JSON.parse(params[:includes])
        else
          includes = []
        end

        includes.select { |include|
          if include.kind_of?(String) || include.kind_of?(Symbol)
            valid_includes.include?(include)
          else
            valid_includes.include?(include.first)
          end
        }
      else
        []
      end
    end

    def lookup(params = {}, diverst_request = nil, base: self)
      # get the search value
      searchValue = params[:search]

      # set the includes/joins arrays
      includes = []
      joins = []

      query_scopes = set_query_scopes(params)

      # the custom args where/where_not clauses
      where = {}
      where_not = {}

      # get the base includes/joins and base query
      includes = get_includes(params)
      preloads = get_preloads(params)
      attachment_preloads = get_attachments(params)
      joins = get_joins
      query = get_base_query

      add_custom_args(where, where_not, params, includes, joins)

      current_user = diverst_request.user

      begin
        policy_name = self.name + 'Policy'
        policy_scope = (policy_name + '::Scope').constantize

        # Raise error if Policy exists but Scope doesn't
        # When scope is not defined it defers to ApplicationPolicy::Scope which has logic we don't necessarily want
        raise NameError if policy_scope.parent != policy_name.constantize

        # Apply the associated policy scope for the model to filter based on authorization
        @items = policy_scope.new(current_user, base, params: params).resolve
      rescue NameError
        # TODO: Uncomment this when we have more policies defined. Commenting now to pass tests early.
        # raise PolicyScopeNotFoundException
        warn(
          '---------------------------------------',
          '! WARNING !',
          "It is likely that a policy scope was not found for #{self}. Ensure that a proper Policy and Scope exist, and filter if necessary (by enterprise, etc.)",
          '---------------------------------------'
        )
        @items = self
      end

      # search the system
      if searchValue.present?
        @items
            .joins(joins)
            .includes(includes)
            .preload(preloads)
            .send_chain(query_scopes)
            .where(query, search: "%#{searchValue}%".downcase)
            .where(where)
            .where.not(where_not)
            .references(includes)
            .distinct
      else
        @items
            .joins(joins)
            .includes(includes)
            .preload(preloads)
            .send_chain(query_scopes)
            .where(where)
            .where.not(where_not)
            .all
            .distinct
      end
    end

    def get_base_query
      return {} unless self.respond_to? :base_query

      self.base_query
    end

    def get_includes(params)
      base_includes = if self.respond_to? :base_includes
        self.base_includes
      else
        []
      end

      param_includes = set_includes(params)
      base_includes | param_includes
    end

    def get_preloads(params)
      if params[:preload].present? && (self.respond_to? "base_preloads_#{params[:preload]}")
        self.send("base_preloads_#{params[:preload]}")
      elsif self.respond_to? :base_preloads
        self.base_preloads
      else
        []
      end
    end

    def get_attachments(params)
      if self.respond_to? :preload_attachments
        self.preload_attachments.map { |field| "with_attached_#{field}" }
      else
        []
      end
    end

    def get_joins
      return [] unless self.respond_to? :base_joins

      self.base_joins
    end

    def query_arguments
      attribute_names
    end

    def query_arguments_hash(query, value)
      value = nil if value === 'null'
      case query
      when *query_arguments
        { query.to_sym => value }
      else
        {}
      end
    end

    # def add_custom_args(where, where_not, params, includes, joins)
    #   # check if the argument is defined in the class as a query argument
    #   params.each do |arg|
    #     if query_arguments.include?(arg.first.to_s)
    #       where.merge!(query_arguments_hash(arg.first.to_s, params[arg.first.to_sym]))
    #     elsif query_arguments.include?(arg)
    #       where.merge!(query_arguments_hash(arg, params[arg]))
    #     end
    #   end
    # end

    def add_custom_args(where, where_not, params, includes, joins)
      # check if the argument is defined in the class as a query argument
      params.each do |arg|
        original_arg = arg
        if arg.first.to_s == '$'
          to_add = where_not
          arg = arg[1..-1]
        else
          to_add = where
        end
        if query_arguments.include?(arg.first.to_s)
          to_add.merge!(query_arguments_hash(arg.first.to_s, params[arg.first.to_sym]))
        elsif query_arguments.include?(arg)
          to_add.merge!(query_arguments_hash(arg, params[original_arg]))
        end
      end
    end

    def elasticsearch(diverst_request, params)
      response = self.__elasticsearch__.search params[:search], size: params[:count].to_i || 10, from: (params[:page].to_i - 1) * (params[:count].to_i || 10)
      Page.new(response.results.response.records.to_a, response.results.total)
    rescue => e
      raise BadRequestException.new(e.message)
    end
  end
end
