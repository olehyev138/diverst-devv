module BaseGraph
  # BaseGraph jobs, purpose:
  #   - parses & formats data returned by BaseSearch for use by frontend

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
  # Generally the 3 main steps to build a graph are:
  class GraphBuilder
    attr_accessor :enterprise_filter, :query, :formatter

    def initialize(instance)
      @instance = instance

      @query = @instance.get_query
      @formatter = get_formatter
    end

    # Query elasticsearch with the current query object and enterprise filter
    # Returns elasticsearch query results
    #  - returns results, because specific logic may want to be performed on them
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
    # Helpers are methods for building common 'types' of graphs

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
  class Nvd3Formatter
    attr_accessor :title, :type

    def initialize
      @title = 'Default Graph'
      @type = 'bar'

      @data = {
        series: []
      }

      # Counter of current series. A series being a single list of data points
      # Initialize with one series
      @current_series = 0
      @data[:series] << { key: "series#@current_series", values: [] }
    end

    # Parse, format & add a single element to current series
    # @element - the element to add
    #  - in the form of a single elasticsearch aggregation element: { key: <key>, doc_count: <n> }
    # @children - optional, a list of children elements
    # @element_key - the key to identify parent element, gives a name to children series
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
    #  - in the form of a list of elasticsearch aggergations elements: [{ key: <key>, doc_count: <n> }, ...n]
    def add_elements(elements)
      @data[:series][@current_series][:values] = format_elements(elements)
    end

    # Parse and return key of element
    # @element - the element to parse
    def get_element_key(element)
      element[:key]
    end

    # Add a new series
    # All elements added will be now added to this series
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
      # Standard form of an elasticsearch element is: { key: <key>, doc_count: <doc_count> }
      # Map to a standard Nvd3 element which is: { key: <label>, doc_count: <value> }
      # Element is synonymous with point or data point, ie (x, y)
      # <label> and <value> can be thought of as an (x, y) point respectively

      {
        label: element[:key],
        value: element[:doc_count],
        children: []
      }
    end
  end

  # Subclass of Nvd3Formatter
  # Allows for custom element and key formatting through passed in lambdas
  class CustomNvd3Formatter < Nvd3Formatter
    attr_accessor :element_formatter, :key_formatter

    # Reimplements add_element slightly to allow for custom arguments
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
