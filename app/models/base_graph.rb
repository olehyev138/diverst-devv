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

    def get_nvd3_hits_formatter(element_formatter, key_formatter)
      Nvd3HitsFormatter.new(element_formatter, key_formatter)
    end
  end

  class GraphBuilder
    def initialize(query, instance, formatter)
      @instance = instance
      @formatter = formatter
      @query = query
    end

    def graph
      results = @instance.search(query)
      @formatter.add_element_list(results)

      self
    end

    def drilldown_graph(parent_field:)
      # parent_field - field to filter parents on

      # Define an initial 'missing aggregation to get parents'
      parents_query = UserGroup.get_query
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
    def initialize
      @data = {
        title: 'Default Graph',
        type: 'nvd3',
        values: []
      }
    end

    def add_element(element, children: nil, element_key: nil)
      element = format_element(element)

      if !children.blank?
        element[:children] = {
          key: element_key,
          values: format_elements(children)
        }
      end

      @data[:values] << element
    end

    def add_elements(elements)
      @data[:values] << format_elements(elements)
    end

    def get_element_key(element)
      element[:key]
    end

    def format
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

  class Nvd3HitsFormatter < Nvd3Formatter
    def initialize(element_formatter, key_formatter)
      @element_formatter = element_formatter
      @key_formatter = key_formatter

      @data = {
        title: 'Default Graph',
        type: 'nvd3',
        values: []
      }
    end

    def get_element_key(element)
      @key_formatter.call element
    end

    def format
      @data
    end

    private

    def format_element(element)
      @element_formatter.call element
    end
  end
end
