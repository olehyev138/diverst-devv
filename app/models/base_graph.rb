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
    attr_accessor :enterprise_filter, :query, :formatter

    def initialize(instance)
      @instance = instance

      @query = @instance.get_query
      @formatter = get_formatter
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

    def get_formatter
      Nvd3Formatter.new
    end

    def get_custom_formatter
      CustomNvd3Formatter.new
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

      parents = @instance.search(parents_query, @enterprise_filter)

      # For each parent, run current set query on all children
      parents.each do |parent|
        # Get key that identifies current parent in mapping
        parent_key = @formatter.get_element_key(parent)

        # Define a filter query to get only children of current parent
        # Wrap around current set query
        children_query = @instance.get_query
          .filter_agg(field: parent_field, value: parent_key) { |_| @query }

        children = @instance.search(children_query, @enterprise_filter)

        # Add current parent with all its children
        @formatter.add_element(parent, children: children, element_key: parent_key)
      end

      self
    end
  end

  # Formats & Parses elasticsearch responses to a Nvd3 Format
  # General Nvd3 data structure:
  #  { title: <title>, type: <type>, series: [{
  #      # series 01
  #      key: <series_name>,
  #      values: [{
  #        # data point 01
  #        label: <label>
  #        value: <value>
  #        children: { key: <parent_label>, values: [ {label: <label>, value: <value>}, ...] }},
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
    attr_accessor :title, :type

    def initialize
      @title = 'Default Graph'
      @type = 'bar'

      @data = {
        series: []
      }

      # Counter of current series. A series being a single list of data points
      # Initialize with first series
      @current_series = 0
      @data[:series] << { key: "series#@current_series", values: [] }
    end

    # Parse, format & add a single element to current series
    # @element - the element to add
    #  - in the form of a single elasticsearch aggregation element: { key: <key>, doc_count: <n> }
    # @children - optional, a list of children elements
    # @element_key - the key to identify a parent element, gives a name to children series
    def add_element(element, children: nil, element_key: nil)
      element = format_element(element)

      if !children.blank?
        element[:children] = {
          key: element_key,
          values: format_elements(children)
        }
      end

      @data[:series][@current_series][:values] << element
    end

    # Parse, format & add a list of elements to current series
    # @elements - the list of elements to add
    #  - in the form of a list of elasticsearch aggregations elements: [{ key: <key>, doc_count: <n> }, ...n]
    def add_elements(elements)
      @data[:series][@current_series][:values] = format_elements(elements)
    end

    # Parse and return key of element
    # @element - the element to parse
    def get_element_key(element)
      element[:key]
    end

    # Add a new series
    # All elements added will be now added to this new series
    def add_series
      @current_series += 1
      @data[:series] << { key: "series#@current_series", values: [] }
    end

    # Returns the dataset formatted to Nvd3, ready to be passed to frontend
    def format
      # Set these properties here so user can change them beforehand
      @data[:title] = @title
      @data[:type] = @type
      @data
    end

    private

    def format_elements(elements)
      elements.map { |element|
        format_element element
      }
    end

    def format_element(element)
      # Maps a single elasticsearch element to a nvd3 element
      # Elasticsearch element looks like: { key: <key>, doc_count: <doc_count> }

      {
        label: element[:key],
        value: element[:doc_count],
        children: {}
      }
    end
  end

  # Subclass of Nvd3Formatter
  # Allows for custom element and key formatting through passed in lambdas
  # Depending on the query, elasticsearch does not always return a standard elasticsearch element
  # For these cases the CustomNvd3Formatter is provided, the methods which parse elasticsearch
  # and map to a nvd3 format, are passed in as lambdas, defined by the user
  #
  # Defines element_formatter and key_formatter instance variables that can be set by the user,
  # if left undefined behavior will default to super. It is possible to set one without setting other
  #
  # element_formatter maps a single elasticsearch element to a nvd3 one
  #  - definition is expected to have at least one argument to take elasticsearch element
  #  - can take extra arguments, simply pass them as normal to add_element
  # key_formatter pulls out the key/identifier of a single elasticsearch element
  #  - definition is expected to have at least one argument to take elasticsearch element
  #  - can take extra arguments, simply pass them as normal to add_element
  #
  class CustomNvd3Formatter < Nvd3Formatter
    attr_accessor :element_formatter, :key_formatter

    # Reimplement add_element slightly to allow the custom lambdas to take extra arguments
    def add_element(element, *args, children: nil, element_key: nil)
      element = format_element(element, *args)

      if !children.blank?
        element[:children] = {
          key: element_key,
          values: format_elements(children, *args)
        }
      end

      @data[:series][@current_series][:values] << element
    end

    def get_element_key(element, *args)
      if !@key_formatter.blank?
        @key_formatter.call element, *args
      else
        super
      end
    end

    private

    def format_elements(elements, *args)
      elements.map { |element|
        format_element element, *args
      }
    end

    def format_element(element, *args)
      if !@element_formatter.blank?
        @element_formatter.call element, *args
      else
        super
      end
    end
  end
end
