module BaseSearcher
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_query
      "CAST(#{self.table_name}.id as varchar(25)) LIKE :search"
    end

    def lookup(params = {}, diverst_request = nil)
      # get the search value
      searchValue = params[:search]

      # set the includes/joins arrays
      includes = []
      joins = []

      # the custom args where/where_not clauses
      where = {}
      where_not = {}

      # get the base includes/joins and base query
      includes = get_includes
      joins = get_joins
      query = get_base_query

      add_custom_args(where, where_not, params, includes, joins)

      # search the system
      if searchValue.present?
        self.joins(joins)
            .includes(includes)
            .where(query, search: "%#{searchValue}%".downcase)
            .where(where)
            .where.not(where_not)
            .references(includes)
            .distinct
      else
        self.joins(joins)
            .includes(includes)
            .where(where)
            .where.not(where_not)
            .all
            .distinct
      end
    end

    def get_base_query
      return {} if not self.respond_to? :base_query

      self.base_query
    end

    def get_includes
      return [] if not self.respond_to? :base_includes

      self.base_includes
    end

    def get_joins
      return [] if not self.respond_to? :base_joins

      self.base_joins
    end

    def query_arguments
      attribute_names
    end

    def query_arguments_hash(query, value)
      case query
      when *query_arguments
        { query.to_sym => value }
      else
        {}
      end
    end

    def add_custom_args(where, where_not, params, includes, joins)
      # check if the argument is defined in the class as a query argument
      params.each do |arg|
        if query_arguments.include?(arg.first.to_s)
          where.merge!(query_arguments_hash(arg.first.to_s, params[arg.first.to_sym]))
        elsif query_arguments.include?(arg)
          where.merge!(query_arguments_hash(arg, params[arg]))
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
