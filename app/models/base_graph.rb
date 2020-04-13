module BaseGraph
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    # Returns an instance of GraphBuilder
    def get_graph_builder
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
  # 2. Setting the ElasticsearchQuery object.
  #     - As defined in BaseSearch, ElasticsearchQuery represents an elasticsearch query. An initial instance is accesed
  #       through the query instance variable. Ie: graph.query = graph.query.terms_agg(...)
  # 3. Searching
  #     - Simply, querying elasticsearch with the current set ElasticsearchQuery object. This returns a raw unformatted
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
  #    to reuse this logic, so as to avoid redundancy. These helpers do the searching and formatting.
  #     So that all that is needed is  to define a enterprise_filter & ElasticsearchQuery object
  #
  class GraphBuilder
    attr_accessor :query, :formatter
    attr_reader :enterprise_filter

    def initialize(instance)
      @instance = instance

      @query = @instance.get_query
      @formatter = get_new_formatter
    end

    def set_enterprise_filter(field: 'enterprise_id', value:)
      @enterprise_filter = { field: field, value: value }
    end

    # Query elasticsearch with the current query object and enterprise filter
    # Returns elasticsearch query results
    #  - returns results, because specific logic may be needed to be performed on them
    #  - results are then added back into graph formatter manually
    def search
      @instance.search @query, @enterprise_filter
    end

    # Runs the formatter and returns results
    #  - generally last step in graph building process
    def build
      @formatter.format
    end

    def get_new_query
      @instance.get_query
    end

    def get_new_parser
      ElasticsearchParser.new
    end

    def get_new_formatter
      VegaLiteFormatter.new
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

      parents = @formatter.parser
        .get_elements(@instance.search(parents_query, @enterprise_filter))

      # For each parent, run current set query on all children
      parents.each do |parent|
        # Get key that identifies current parent in mapping
        parent_key = @formatter.get_element_key(parent)

        # Define a filter query to get only children of current parent
        # Wrap around current set query
        children_query = @instance.get_query
          .filter_agg(field: parent_field, value: parent_key) { |_| @query }

        children = @formatter.parser
          .get_elements(@instance.search(children_query, @enterprise_filter))

        # Add current parent with all its children
        @formatter.add_element(parent, children: children, element_key: parent_key)
      end
    end

    def stacked_nested_terms(elements)
      # Reformat's an elasticsearch nested terms response to a nvd3 stacked/grouped bar chart
      # ES has all child buckets nested inside parent bucket
      # Nvd3 represents each child element/'stack' as a separate *series*
      #  ex: Ergs aggregated on certifications would have each certification name as
      #      a separate series. Ie all elements for cert-01 would be in the cert-01 series
      #      Each elements key in a series is set to the parents element name.
      #      This ties elements to a parent and sets the y axis label
      #  structure: [ { series: 'cert-01', values: [ { key: 'group-01', value: 5 } ] },
      #               { series: 'cert-02', values: [ { key: 'group-01', values: 9} ] } ]

      parser = formatter.parser
      custom_parser = get_new_parser
      child_element_extractor = parser.nested_terms_list

      elements.each do |element|
        parent_name = custom_parser.parse(element)[:x]

        parser.get_elements(element, extractor: child_element_extractor).each do |child_element|
          child_name = custom_parser.parse(child_element)[:x]

          formatter.add_series(series_name: child_name)
          parser.extractors[:x] = -> (_, args) { args[:parent_name] }
          parser.extractors[:y] = parser.date_range(key: :doc_count)
          formatter.add_element(child_element, series_key: child_name, parent_name: parent_name)
        end
      end

      self
    end
  end

  class VegaLiteFormatter
    attr_accessor :title, :x_label, :y_label, :type, :filter_zeros, :parser

    def initialize
      @title = 'Default Graph'
      @type = 'bar'

      @parser = ElasticsearchParser.new

      @series_index = -1
      @data = {
          values: []
      }
    end

    # Parse, format & add a single element to data array
    # @element - the element to add
    #  - in the form of a single elasticsearch aggregation element: { key: <key>, doc_count: <n> }
    def add_element(es_element, series_name: @title, **args)
      element = format_element(es_element, series_name: series_name, **args)
      @data[:values] << element
    end

    # Parse, format & add a list of elements to current series
    # @elements - the list of elements to add
    #  - in the form of a list of elasticsearch aggregations elements: [{ key: <key>, doc_count: <n> }, ...n]
    def add_elements(elements, series_index: @series_index, **args)
      add_series if @data.dig([:series][series_index]).blank?
      @data[:series][series_index][:values] = format_elements(elements, args)
    end

    # Parse and return key of element
    # Key is the thing that uniquely identifies the item
    # Usually this is the same as the x value, but not always
    # @element - the element to parse
    def get_element_key(element, key: :x)
      @parser.parse(element)[key]
    end

    # Returns the dataset formatted to Vega Lite, ready to be passed to frontend
    def format
      # Set these properties here so user can change them beforehand
      @data[:title] = @title
      @data[:x_label] = @x_label
      @data[:y_label] = @y_label
      @data[:type] = @type

      @data
    end

    private

    def format_elements(elements, **args)
      elements.map { |element|
        format_element(element, args)
      }
    end

    def format_element(element, series_name: @title, **args)
      values = @parser.parse(element, args)
      values[:series] = series_name
      values
    end
  end

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
    attr_accessor :title, :x_label, :y_label, :type, :filter_zeros, :parser

    def initialize
      @filter_zeros = true

      @title = 'Default Graph'
      @type = 'bar'

      @parser = ElasticsearchParser.new

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
    def add_element(es_element, element_key: nil, children: nil, series_key: nil, **args)
      element = format_element(es_element, args)

      # add children to element if passed
      if children.present?
        element[:children] = {
          key: element_key || get_element_key(es_element),
          values: format_elements(children, args)
        }
      end

      # create a series for element if necessary & add element to current series
      # if series is specified, find it and pull it out, otherwise get series using current index
      add_series if @data.dig(:series, @series_index).blank?
      series = series_key.present? ? @data[:series].find { |s| s.dig(:key) == series_key }
                                   : @data[:series][@series_index]
      series[:values] << element
    end

    # Parse, format & add a list of elements to current series
    # @elements - the list of elements to add
    #  - in the form of a list of elasticsearch aggregations elements: [{ key: <key>, doc_count: <n> }, ...n]
    def add_elements(elements, series_index: @series_index, **args)
      add_series if @data.dig([:series][series_index]).blank?
      @data[:series][series_index][:values] = format_elements(elements, args)
    end

    # Parse and return key of element
    # Key is the thing that uniquely identifies the item
    # Usually this is the same as the x value, but not always
    # @element - the element to parse
    def get_element_key(element, key: :x)
      @parser.parse(element)[key]
    end

    # Add a new series
    # @series_name - optional, default is title
    # All elements added after will be added to this new series
    def add_series(series_name: @title)
      return if @data[:series].any? { |h| h[:key] == series_name }

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

      if filter_zeros
        @data[:series].each_with_index do |series, i|
          @data[:series][i][:values] = series[:values].select { |e| e[:x] != 0 && e[:y] != 0 }
        end
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
      values = @parser.parse(element, args)
      values[:children] = {}
      values
    end
  end

  # Parse an elasticsearch response
  # - ElasticsearchParser works in the same fashion as ElasticsearchQuery
  # - Contains a list of small methods which return lambdas that parse a
  #   specific aggregation type. Not all aggregations change the response format,
  #   so these are not included
  # - These lambdas can be nested to any level to match a nested aggregation query
  # - Ex: If you ran a date range with a sum nested inside, you would call the
  #   date_range method and then nest sum inside
  #     - like so: parser.date_range { |p| p.sum(key: :doc_count) }
  #   - We call these lambdas extractors. An extractor when run, extracts or parses
  #     one value from the elasticsearch response.
  # - ElasticsearchParser has public hash called 'extractors' to store a list of these
  #   lambdas. The key for each lambda is the name or label you want to call the value it extracts
  # - The workflow is something like this:
  #  -  1) You build up the extractors hash to any degree
  #         ex: parser.extractors[:x] = parser.date_range { |p| p.sum(key: :doc_count) }
  #  -  2) You run parse, passing a single elasticsearch element,
  #        parse runs through the extractors hash building a 'values' hash,
  #        each key,value pair is the key of the extractor and the return value of the extractor
  #        ex: a extractors hash like: { x: <lambda_x>  } maps to: { x: <lambda_x_return_value> }
  #
  #  ElasticsearchParser also has a method: 'get_elements'
  #  'get_elements' takes a type of extractor that returns a list of elements, which can then
  #  be iterated over, each being passed to 'parse'
  class ElasticsearchParser
    attr_accessor :extractors

    def initialize(key: :key)
      @extractors = {
        x: -> (e, _) { e[:key] },
        y: -> (e, _) { e[:doc_count] }
      }
    end

    def date_range(key: nil, &block)
      inner = yield self if block_given?

      -> (e, args) {
        e = e.try(:agg).try(:buckets).try(:dig, 0) || 0
        (inner) ? inner.call(e, args) : (e.try(:dig, key) || 0)
      }
    end

    def agg(key: nil, &block)
      inner = yield self if block_given?

      -> (e, args) {
        e = e.try(:agg) || 0
        (inner) ? inner.call(e, args) : (e.try(:dig, key) || 0)
      }
    end

    def sum(key: nil, &block)
      inner = yield self if block_given?

      -> (e, args) {
        e = e.try(:agg).dig(:value) || 0
        (inner) ? inner.call(e, args) : (e.try(:dig, key) || 0)
      }
    end

    def top_hits(key: nil, &block)
      inner = yield self if block_given?

      -> (e, args) {
        e = e.try(:agg).try(:hits).try(:hits).try(:dig, 0, '_source') || 0
        (inner) ? inner.call(e, args) : (e.try(:dig, key) || 0)
      }
    end

    def custom(custom_extractor, &block)
      inner = yield self if block_given?

      -> (e, args) {
        e = custom_extractor.call(e, args)
        (inner) ? inner.call(e) : e
      }
    end

    def nested_terms_list(&block)
      inner = yield self if block_given?

      -> (e, args) {
        e = e.try(:agg).try(:buckets) || []
        (inner) ? inner.call(e, args) : e
      }
    end

    # parse a es response to return a list of elements
    def get_elements(response, extractor: nil, **args)
      return response if extractor.blank?

      extractor.call(response, args)
    end

    # Run the parser on an elasticsearch element
    def parse(element, **args)
      values = {}

      @extractors.each do |label, extractor|
        values[label] = extractor.call(element, args)
      end

      values
    end
  end
end
