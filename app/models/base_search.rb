module BaseSearch
  # BaseSearch jobs, purpose:
  #   - deals with searching the database, ie elasticsearch
  #   - builds & runs es queries
  #   - pulls out response data and returns

  # Todo:
  #   - documentation


  def self.included(klass)
    klass.extend ClassMethods
  end

  class Query
    # builds an elasticsearch query through the builder pattern
    # todo:
    #  - support non aggregate queries
    #  - add support for basic options, ie size
    #  - remove agg function repetition

    DEFAULT_SIZE = 0

    def initialize
      @query = {size: DEFAULT_SIZE}
      @aggs = {aggs: {}}
    end

    def filter_agg(field:, value:, agg_name: 'agg')
      agg = { agg_name => { filter: { term: { field => value } } } }

      if block_given?
        agg[agg_name].merge!({ aggs:
          (yield Query.new)[:aggs]
        })
      end

      @aggs[:aggs].merge! agg

      self
    end

    def date_range_agg(field:, range:, agg_name: 'agg')
      agg = { agg_name =>
        { date_range: { field: field, ranges: [ range ] }}}

      if block_given?
        agg[agg_name].merge!({ aggs:
          (yield Query.new)[:aggs]
        })
      end

      @aggs[:aggs].merge! agg

      self
    end

    def top_hits_agg(size: 100, agg_name: 'agg')
      agg = { agg_name => { top_hits: { size: size } } }

      if block_given?
        agg[agg_name].merge!({ aggs:
          (yield Query.new)[:aggs]
        })
      end

      @aggs[:aggs].merge! agg

      self
    end

    def agg(type:, field:, agg_name: 'agg', order_clause: nil)
      # agg_name can all be 'agg' as long as aggs arnt adjacent, ie duplciate keys

      agg = { agg_name => { type => { field: field } } }

      # temporary ugly order clause code - TODO: fix
      if !order_clause.blank?
        agg[agg_name][type].merge! order_clause
      end

      if block_given?
        # if a block is given, nest the returned aggregations inside our current aggregation
        # yield returns a built es query hash, we pull out the agg section and merge it.
        agg[agg_name].merge!({ aggs:
          (yield Query.new)[:aggs]
        })
      end

      @aggs[:aggs].merge! agg

      self
    end

    def build
      if !@aggs[:aggs].blank?
        @query.merge! @aggs
      end

      @query
    end
  end

  module ClassMethods
    def get_query
      Query.new
    end

    def search(query)
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
