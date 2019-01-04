module BaseSearch

  # BaseSearch jobs, purpose:
  #   - takes a custom dsl, transaltes & builds es queries
  #   - runs es queries, pulls out response data and returns

  # Todo:
  #   - build objects to represent custom dsl to simplify and
  #     increase readability of queries to BaseSearch
  #   - Add ability to deal with ranges (dates, integer)
  #   - Add ability to deal with exclusions (ex. Users who are in Group A, B but not in C)
  #   - Build default queries


  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods

    def search(params)
      #if params[:format] && params[:format] === "csv" - check if
      #if params[:dummy] - check if we would return dummy data
      #if params[:drilldowns] - check if we need to query for children data
      hash = build(params)
      return run(hash, params)
    end

    def build(params)
      # probably need some way to build a default query in case an error happens in syntax or incorrect
      # params are passed
      search = {size: 100}

      # check if theres an aggregation and start building query hash and then aggregation hash second
      if params[:search][:aggregations]
        search.merge!(query(params))
        search.merge!(aggregate(params))
      else
        # if not aggregation then we build the query hash and then filter hash
        search.merge!(query(params))
        search.merge!(filter(params))
      end

      return search
    end

    # query method builds the query hash by taking terms and adding them to the
    # filter hash. ex: params = {:query => [{id: 1, mentor: true}]}

    def query(params)
      return {} if params[:search].dig(:fields).nil?
      return {} if params[:search][:fields].empty?

      # takes the values to search and builds the query hash
      # ex. params = {:search => {:fields => [{:name=>"first_name", :value=>"Jack", :type=>"string"}]}}
      # returns

      hash = {query: {match: {}}}

      params[:search][:fields].each do |field|
        hash[:query][:match].merge!({"#{field[:name]}": field[:value]})
      end

      return hash
    end

    # takes the values to filter and builds the filter hash
    # ex. params = {:search => {:filters => [{:name=>"mentor", :value=>true, :type=>"boolean"}]}}
    # returns

    def filter(params)
      return {} if params[:search].dig(:filters).nil?
      return {} if params[:search][:filters].empty?
      filter = {filter: {term: {}}}

      params[:search][:filters].each do |field|
        filter[:filter][:term].merge!({"#{field[:name]}": field[:value]})
      end

      return filter
    end

    # takes the values to aggregate and builds the aggregate hash
    # ex. params = {:search => {:aggregations => [{:name=>"enterprise_id", :type=>"integer"}]}}

    def aggregate(params)
      return {} if params[:search].dig(:aggregations).nil?
      return {} if params[:search][:aggregations].empty?

      hash = filter(params)
      aggregations = {aggs: {}}

      params[:search][:aggregations].each do |field|
        aggregations[:aggs].merge!(
          {
            aggregations: {
              terms: {
                field: field[:name]
              }
            }
          }
        )
      end

      if !hash.empty?
        return {
          aggs: {
            aggregations: {
              filter: hash[:filter],
              aggs: aggregations[:aggs]
            }
          }
        }
      end

      return aggregations
    end

    def run(hash, params)
      begin
        response = self.__elasticsearch__.search hash

        if params[:search].dig(:aggregations).nil?
          return response.results.response.records.to_a
        else
          if response.aggregations.dig(:aggregations, :aggregations)
            return response.aggregations.aggregations.aggregations.buckets
          else
            return response.aggregations.aggregations.buckets
          end
        end
      rescue => e
        raise BadRequestException.new e.message
      end
    end
  end
end
