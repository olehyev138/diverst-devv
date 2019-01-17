module BaseGraph
  # BaseGraph jobs, purpose:
  #   - acts as a interface/front for BaseSearch
  #   - parses & formats data returned by BaseSearch for use by frontend

  # TODO:
  #   - Restructure formatting stuff to support bucket & top hits aggregations more elegantly
  #       - right now its quite hacked together

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def get_graph(query, title: 'Basic Graph', type: 'nvd3', hits: false, format_block: nil)
      GraphBuilder.new(query, self, title: title, type: type,
        hits: hits, format_block: format_block)
    end
  end

  class GraphBuilder
    # TODO: deal with this hits and custom block stuff, super gross and hacky right now

    def initialize(query, instance, title: 'Basic Graph', type: 'nvd3', hits: false, format_block: nil)
      @title = title
      @type = type

      @instance = instance
      @formatter = Nvd3Formatter.new(title, type, format_block: format_block)

      @hits = hits

      # TODO: put this somewhere more appropiate
      @results = @instance.search(query)
      if hits
        @results = @results[0].agg.hits.hits
      end
    end

    def graph
      @formatter.add_bucket_list(@results)

      self
    end

    def drilldown_graph(query:, parent_field:, parent_key_block: nil)
      # parent_field    - field to use to filter parents on

      # cycle parents
      @results.each do |parent|
        # build a query to get all child documents of current parent
        # filter documents on current parent name

        if parent_key_block
          parent_key = parent_key_block.call parent
        else
          parent_key = parent[:key]
        end

        children_query = @instance.get_query
          .filter_agg(field: parent_field, value: parent_key) { |_| query }.build

        children = @instance.search(children_query)

        if @hits
          children = children[0].agg.hits.hits
        end

        @formatter.add_bucket(parent, children: children, parent_key: parent_key)
      end

      self
    end

    def build
      @formatter.format
    end
  end

  class Nvd3Formatter
    # Handles all formatting elasticsearch responses for the Nvd3 library
    # TODO:
    #  - handle hits, custom formatting block more elegantly
    #  - should define some kind of 'formatter interface' then make one for buckets
    #    and one for hits

    def initialize(title, type, format_block: nil)
      @data = {
        key: title,
        type: type,
        values: []
      }

      @format_block = format_block
    end

    def add_bucket(bucket, children: nil, parent_key: nil)
      parent = format_bucket(bucket)

      if children
        parent[:children] = {
          key: (parent_key.to_s + '_subgroups').downcase,
          values: format_bucket_list(children)
        }
      end

        @data[:values] << parent
    end

    def add_bucket_list(buckets)
      @data[:values] << format_bucket_list(buckets)
    end

    def add_hits(bucket)
      # Formats a response where bottom agg is a 'top_hits' aggregation
      # ES returns a very different format. A list of 'hits' inside a single bucket
      # A single hit contains an entire document. So have user define a block to format a hit

      hits = bucket[0].agg.hits.hits
      hits.each do |hit|
        @data[:values] << (yield hit)
      end
    end

    def format
      @data
    end

    private

    def format_bucket_list(buckets)
      buckets.map { |bucket|
        format_bucket bucket
      }
    end

    def format_bucket(bucket)
      if @format_block
        @format_block.call bucket
      else
      {
        label: bucket[:key],
        value: bucket[:doc_count],
        children: []
      }
      end
    end
  end
end
