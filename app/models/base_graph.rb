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
    def get_graph(query, formatter)
      GraphBuilder.new(query, self, formatter)
    end

    def get_nvd3_formatter
      Nvd3Formatter.new
    end

    def get_nvd3_custom_formatter(element_formatter: nil, key_formatter: nil)
      Nvd3CustomFormatter.new(element_formatter: element_formatter, key_formatter: key_formatter)
    end
  end

  class GraphBuilder
    def initialize(query, instance, formatter)
      @instance = instance
      @formatter = formatter
      @query = query
    end

    def drilldown_graph(parent_field:)
      # parent_field - field to filter parents on

      # Define an initial 'missing aggregation' to get parents, ie filter where parent_field is nil
      parents_query = @instance.get_query
        .agg(type: 'missing', field: parent_field) { |_| @query }.build

      parents = @instance.search(parents_query)

      parents.each do |parent|
        parent_key = @formatter.get_element_key(parent)

        # build a query to get all child documents of current parent
        children_query = @instance.get_query
          .filter_agg(field: parent_field, value: parent_key) { |_| @query }.build

        children = @instance.search(children_query)

        @formatter.add_element(parent, children: children, element_key: parent_key)
      end

      self
    end

    def build
      @formatter.format
    end
  end

  class Nvd3Formatter
    # TODO:
    #  - element key should not be optional
    #  - allow for custom title, type, series names

    attr_accessor :title
    attr_accessor :type

    def initialize
      # defaults
      @title = 'Default Graph'
      @type = 'bar'

      @data = {
        series: []
      }

      @current_series = 0
      @data[:series] << { key: "series#@current_series", values: [] }
    end

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

    def add_elements(elements)
      @data[:series][@current_series][:values] = format_elements(elements)
    end

    def get_element_key(element)
      element[:key]
    end

    def add_series
      @current_series += 1
      @data[:series] << { key: "series#@current_series", values: [] }
    end

    def format
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
      {
        label: element[:key],
        value: element[:doc_count],
        children: []
      }
    end
  end

  class Nvd3CustomFormatter < Nvd3Formatter
    def initialize(element_formatter: nil, key_formatter: nil)
      @element_formatter = element_formatter
      @key_formatter = key_formatter

      super()
    end

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
