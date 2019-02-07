module BaseSearch
  # BaseSearch jobs, purpose:
  #   - deals with searching the database, ie elasticsearch
  #   - builds & runs es queries
  #   - pulls out response data and returns

  def self.included(klass)
    klass.extend ClassMethods
  end

  class Query
    # builds an elasticsearch query through the builder pattern

    DEFAULT_SIZE = 0

    def initialize
      @query = {size: DEFAULT_SIZE}
      @aggs = {aggs: {}}
    end

    def filter_agg(field:, value:, &block)
      agg = { agg: { filter: { term: { field => value } } } }
      base_agg(agg, block)
    end

    def date_range_agg(field:, range:, &block)
      agg = { agg: { date_range: { field: field, ranges: [ range ] }}}
      base_agg(agg, block)
    end

    def top_hits_agg(size: 100, &block)
      agg = { agg: { top_hits: { size: size } } }
      base_agg(agg, block)
    end

    def terms_agg(field:, order_field: '_count', order_dir: 'desc', &block)
      agg = { agg: { terms: { field: field, order: { order_field => order_dir } } } }
      base_agg(agg, block)
    end

    def agg(type:, field:, &block)
      # generic agg function, most aggs follow this form, just type needs specification
      agg = { agg: { type => { field: field } } }
      base_agg(agg, block)
    end

    def build
      if !@aggs[:aggs].blank?
        @query.merge! @aggs
      end

      @query
    end

    private

    def base_agg(agg, block)
      if block
        # if a block is given, nest the returned aggregations inside our current aggregation
        # yield returns a built es query hash, we pull out the agg section and merge it.
        agg[:agg].merge!({ aggs:
          (block.call Query.new).build[:aggs]
        })
      end

      @aggs[:aggs].merge! agg
      self
    end
  end

  module ClassMethods
    def get_query
      Query.new
    end

    def search(query, enterprise_filter)
      # wrap all queries in a filter on enterprise_id
      query = self.get_query.filter_agg(field: enterprise_filter.keys[0],
                                        value: enterprise_filter.values[0]) { |_| query }.build
      begin
        response = (self.__elasticsearch__.search query).response

        if response.aggregations
          response = (get_deepest_agg response.aggregations.agg).buckets

          # check for hits
          if response.count == 1 && response[0].agg
            response[0].agg.hits.hits
          else
            response
          end
        else
          return response
        end
      rescue => e
        raise BadRequestException.new e.message
      end
    end

    def get_deepest_agg(agg)
      # recursive function to get deepest agg in elasticsearch response
      if agg.agg.blank?
        agg
      else
        get_deepest_agg agg.agg
      end
    end
  end
end
