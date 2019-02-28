module BaseSearch
  def self.included(klass)
    klass.extend ClassMethods
  end

  # Represents and builds an elasticsearch aggregation query
  # Essentially a list of methods that take parameters and builds
  # a hash out of them, reperesenting various elasicsearch aggregation types
  #
  # Supports nesting to any degree through blocks.
  #   - Block is passed a new ElasticsearchQuery instance.
  #   - Block is expected to return an instance of ElasticsearchQuery, presumambly with
  #     one or more aggregations defined
  #   - A query returned from a block, is nested within the outer query
  #   - Ex: filter_agg(...) { |q| q.terms_agg(...) }
  #          - q is a new instance of ElasticsearchQuery
  #          - This will nested a terms agg within a filter agg
  #   - Consult elasticsearch documentation for more information
  #     on elasticsearch aggregations
  #
  # Limitations:
  #  - Currently will not support 'adjacent' aggregations, because all aggs are named 'agg'
  #     so it would cause a duplicate key error
  #  - Only builds aggregation queries
  #
  class ElasticsearchQuery
    DEFAULT_SIZE = 0

    def initialize
      @query = {size: DEFAULT_SIZE}
      @root_aggs = {aggs: {}}
    end

    # Creates a filter aggregation
    #   - returns all documents with matching value in field
    #   - if trying to filter on nil, consult elasticsearch documentation for 'missing aggregation'
    # @field - field within mapping to filter on
    # @value - value to match on
    def filter_agg(field:, value:, &block)
      agg = { agg: { filter: { term: { field => value } } } }
      base_agg(agg, block)
    end

    # Creates a date range aggregation
    # @field - field to fit within range
    # @range - an elasticsearch range hash, consult elasticsearch documentation for more information
    # limitations - only supports a single range
    def date_range_agg(field:, range:, &block)
      agg = { agg: { date_range: { field: field, ranges: [ range ] }}}
      base_agg(agg, block)
    end

    # Creates a top hits aggregation
    # @size - optional, default: 100, defines number of records to return
    def top_hits_agg(size: 100, &block)
      agg = { agg: { top_hits: { size: size } } }
      base_agg(agg, block)
    end

    # Creates a terms aggregation
    # @field - field to aggregate on
    # @order_field - optional, default: _count, field to order on
    # @order_dir - order direction, deffault: desc, dirction in which to order
    def terms_agg(field:, size: 100, order_field: '_count', order_dir: 'desc', &block)
      agg = { agg: { terms: { field: field, size: size, order: { order_field => order_dir } } } }
      base_agg(agg, block)
    end

    # Creates any aggregation that follows the { type: { field: <field> } } format
    #   - this is the bulk of aggregations
    # @type - the type of aggregation this is, as defined by elasticsearch
    #    - ex, a missing aggregation is defined by elasticsearch as 'misssing' so type would be 'missing'
    # @field - the field in which this aggregation is being performed on
    def agg(type:, field:, &block)
      agg = { agg: { type => { field: field } } }
      base_agg(agg, block)
    end

    def build
      if !@root_aggs[:aggs].blank?
        @query.merge! @root_aggs
      end

      @query
    end

    private

    def base_agg(agg, block)
      if block
        # If a block is given:
        #   - call it, passing a new Query object
        #   - build the returned Query object, pull out the aggs hash
        #   - nest the pulled out aggs hash within our current aggregation hash
        agg[:agg].merge!({ aggs:
          (block.call ElasticsearchQuery.new).build[:aggs]
        })
      end

      @root_aggs[:aggs].merge! agg
      self
    end
  end

  module ClassMethods
    # Returns a ElasticsearchQuery instance
    def get_query
      ElasticsearchQuery.new
    end

    # Runs an elasticsearch query
    # @query - the Query object in which to query elasticsearch with
    # @enterprise_filter - the enterprise field/value pair hash in which to filter on
    def search(query, enterprise_filter)
      # wrap query in a enterprise_id filter
      query = self.get_query.filter_agg(field: enterprise_filter[:field],
                                        value: enterprise_filter[:value]) { |_| query }.build
      begin
        response = (self.__elasticsearch__.search query).response

        if response.aggregations
          # get list of buckets at deepest level of aggregation
          (get_deepest_agg response.aggregations.agg).buckets
        else
          return response
        end
      rescue => e
        raise BadRequestException.new e.message
      end
    end

    def get_deepest_agg(agg)
      # simple recursive function to get deepest agg in elasticsearch response
      if agg.agg.blank?
        agg
      else
        get_deepest_agg agg.agg
      end
    end
  end
end
