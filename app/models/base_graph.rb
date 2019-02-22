module BaseGraph
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    # Returns an instance of GraphBuilder
    def get_graph
      GraphBuilder.new(self)
    end
  end

  # Builds a graph
  # Acts as the interface for the entire framework
  # Interactions with the other framework objects are done through GraphBuilder
  #
  # Generally building a graph includes:
  #  1. Setting an enterprise filter
  #      - An enterprise filter is a key/value pair where key is the field in the
  #        elasticsearch mapping in which the enterprise_id is stored, and value is
  #        current enterprise id. This is so we can filter for objects only in the current enterprise.
  # 2. Setting the Query object.
  #     - As defined in BaseSearch, Query represents an elasticsearch query. An initial instance is accesed
  #       through the query instance variable. Ie: graph.query = graph.query.terms_agg(...)
  # 3. Searching
  #     - Simply, querying elasticsearch with the current set Query object. This returns a raw unformatted
  #       list of elasticsearch elements, or in elasticsearch jargon, 'buckets'
  # 4. Applying logic on elasticsearch results and formatting
  #     - Finally, according to specific needs, logic can be performed on raw results and then formatted for passing
  #       to the frontend
  #     - The Formatter is accessed through the formatter instance variable. Ie: graph.formatter.add_elements(...)
  # 5. Building
  #     - The final step is always to call the build method, this will return the formatted results in a hash.
  #       Ready for use by the frontend
  #
  # Helpers
  #  - Often, the logic being applied in step 4, is common and needed more then once. Helper methods are defined
  #    to reuse this logic,
  #    so as to avoid redundency. These helpers do the searching and formatting. So that all that is needed is
  #    to define a enterprise_filter & Query object
  #
  class GraphBuilder
    attr_accessor :query, :formatter, :hits
    attr_reader :enterprise_filter

    def initialize(instance)
      @instance = instance

      @query = @instance.get_query
      @formatter = Nvd3Formatter.new
      @hits = false
    end

    def set_enterprise_filter(field: 'enterprise_id', value:)
      @enterprise_filter = { field: field, value: value  }
    end

    # Query elasticsearch with the current query object and enterprise filter
    # Returns elasticsearch query results
    #  - returns results, because specific logic may be needed to be performed on them
    #  - results are then added back into graph formatter manually
    def search
      @instance.search @query, @enterprise_filter, hits: @hits
    end

    # Runs the formatter and returns results
    #  - generally last step in graph building process
    def build
      @formatter.format
    end

    # Helpers
    #  - Helpers are methods for building common 'types' of graphs
    #  - Generally a helper should take care of all searching and formatting

    # Builds a 'drilldown' graph.
    # @parent_field - field in mapping to filter parents on
    def drilldown_graph(parent_field:)
      # Define a 'missing aggregation' query to get parents, ie filter where parent_field is nil to get all parents
      # Wrap around current set query
      parents_query = @instance.get_query
        .agg(type: 'missing', field: parent_field) { |_| @query }

      parents = @formatter.list_parser
        .parse_list(@instance.search(parents_query, @enterprise_filter, hits: @hits))

      # For each parent, run current set query on all children
      parents.each do |parent|
        # Get key that identifies current parent in mapping
        parent_key = @formatter.get_element_key(parent)

        # Define a filter query to get only children of current parent
        # Wrap around current set query
        children_query = @instance.get_query
          .filter_agg(field: parent_field, value: parent_key) { |_| @query }

        children = @instance.search(children_query, @enterprise_filter, hits: @hits)

        # Add current parent with all its children
        @formatter.add_element(parent, children: children, element_key: parent_key)
      end

      self
    end
  end

  # Define formatting interface here - TODO

  # Formats & Parses elasticsearch responses to a Nvd3 Format
  # General Nvd3 data structure:
  #  { title: <title>, type: <type>, series: [{
  #      # series 01
  #      key: <series_name>,
  #      values: [{
  #        # data point 01
  #        x: <label>
  #        y: <value>
  #        children: { key: <parent_label>, values: [ {x: <label>, y: <value>}, ...] }},
  #        ...
  #      },
  #      ...
  #    ]
  #  }
  #
  #  A Nvd3 data structure consists of:
  #    - A list of 1 to n series
  #    - A series is a hash with a name and a list of data points: { key: <series_name>, values: [...] }
  #    - A datapoint is a key,value pair, with an optional list of children: { key: <key>, value: <value>, children: {} }
  #    - A children hash is a hash with key identifying parent and a list of data points
  #        - Children data points may not have children of there own. This limits the Nvd3 structure to ONE sublevel of datapoints
  class Nvd3Formatter
    attr_accessor :title, :x_label, :y_label, :type,
                  :x_parser, :y_parser, :list_parser, :key_parser, :general_parser

    def initialize
      @x_parser = ElasticsearchParser.new(key: ElasticsearchParser::ELASTICSEARCH_KEY)
      @y_parser = ElasticsearchParser.new(key: ElasticsearchParser::ELASTICSEARCH_DOC_COUNT)
      @list_parser = ElasticsearchParser.new
      @key_parser = @x_parser
      @general_parser = ElasticsearchParser.new

      @title = 'Default Graph'
      @type = 'bar'

      @series_index = -1
      @data = {
        series: []
      }
    end

    # Parse, format & add a single element to current series
    # @element - the element to add
    #  - in the form of a single elasticsearch aggregation element: { key: <key>, doc_count: <n> }
    # @children - optional, a list of children elements
    # @element_key - the key to identify a parent element, gives a name to children series
    def add_element(element, element_key: nil, children: nil, **args)
      element = format_element(element, args)

      # add children to element if passed
      if children.present?
        element[:children] = {
          key: element_key || get_element_key(element),
          values: format_elements(children, args)
        }
      end

      # create a series for element if necessary & add element to current series
      add_series if @data[:series].blank?
      @data[:series][@series_index][:values] << element
    end

    # Parse, format & add a list of elements to current series
    # @elements - the list of elements to add
    #  - in the form of a list of elasticsearch aggregations elements: [{ key: <key>, doc_count: <n> }, ...n]
    def add_elements(elements, **args)
      add_series if @data[:series].blank?
      @data[:series][@series_index][:values] = format_elements(elements, args)
    end

    # Parse and return key of element
    # Key is the thing that uniquely identifes the item
    # Usually this is the same as the x value, but not always
    # @element - the element to parse
    def get_element_key(element)
      @key_parser.parse(element)
    end

    # Add a new series
    # @series_name - optional, default is title
    # All elements added after will be added to this new series
    def add_series(series_name: @title)
      @series_index += 1
      @data[:series] << { key: series_name, values: [] }
    end

    # Returns the dataset formatted to Nvd3, ready to be passed to frontend
    def format
      # Set these properties here so user can change them beforehand
      @data[:title] = @title
      @data[:x_label] = @x_label
      @data[:y_label] = @y_label
      @data[:type] = @type

      # clean up data
      @data[:series].each_with_index do |series, i|
        @data[:series][i][:values] = series[:values].select { |e| e[:x] != 0 && e[:y] != 0 }
      end

      @data
    end

    private

    def format_elements(elements, **args)
      elements.map { |element|
        format_element(element, args)
      }
    end

    def format_element(element, **args)
      {
        x: @x_parser.parse(element, args),
        y: @y_parser.parse(element, args),
        children: {}
      }
    end
  end

  # Parse a elasticsearch response
  # Pulls a single value out of an elasticsearch response
  # Theoretically could replace with another parser if we switched backends
  class ElasticsearchParser
    ELASTICSEARCH_KEY = :key
    ELASTICSEARCH_DOC_COUNT = :doc_count

    attr_accessor :parse_chain, :key, :extractor

    def initialize(key: :key)
      @key = key
      @parse_chain = -> (e) { e }
    end

    # Bucket parsers
    # Returns a single elasticsearch bucket

    def date_range(&block)
      inner = yield self if block_given?

      -> (e) {
        e = e.agg.buckets[0] || 0
        (inner) ? inner.call(e) : e
      }
    end

    # Parse a top hits aggregation
    # Must be run last, can not nest anything inside except custom parser
    def top_hits
      -> (e) {
        e.agg.hits.hits.dig(0, '_source') || 0
      }
    end

    # List parsers
    # Returns a list of elasticsearch buckets

    def date_range_list
      inner = yield self if block_given?

      -> (e) {
        e = e.agg.buckets
        (inner) ? inner.call(e) : e
      }
    end

    def top_hits_list
      -> (e) {
        e.agg.hits.hits
      }
    end

    # Run the parser on an elasticsearch response
    def parse(element, **args)
      if @extractor.present?
        @extractor.call(@parse_chain.call(element), args)
      else
        @parse_chain.call(element)[@key]
      end
    end

    def parse_list(element)
      @parse_chain.call(element)
    end
  end
end
