module BaseGraph
  # BaseGraph jobs, purpose:
  #   - acts as a interface/front for BaseSearch
  #   - parses & formats data returned by BaseSearch for use by frontend

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def get_graph(title='Basic Graph', type='nvd3', query)
      GraphDataBuilder.new(title, type, query, self)
    end
  end

  class GraphDataBuilder
    def initialize(title='Basic Graph', type='nvd3', query, instance)
      @title = title
      @type = type

      @instance = instance
      @results = @instance.search(query)
      @formatter = Nvd3Formatter.new(title, type)

    end

    def graph(buckets)
      @formatter.add_bucket_list(buckets)

      self
    end

    def drilldown_graph(parent_field)
      # parent_field    - field to use to filter parents on

      # cycle parents
      @results.each do |parent|
        # build a query to get all child documents of current parent
        # filter documents on current parent name, then aggregate on child name
        children_query = @instance.get_query
          .aggregate(type='filter', field=parent_field, value=parent[:key]) { |q|
            q.aggregate(type='terms', field='group.name').build
        }.build

        children = @instance.search(children_query)

        @formatter.add_bucket(parent, children=children)
      end

      self
    end

    def build
      @formatter.format
    end
  end

  class Nvd3Formatter
    # Format elasticsearch responses for the Nvd3 library

    def initialize(title, type)
      @data = {
        key: title,
        type: type,
        values: []
      }
    end

    def add_bucket(bucket, children=nil)
      parent = format_bucket(bucket)

      if children
        parent[:children] = {
          key: bucket[:key] + '_subgroups',
          values: format_bucket_list(children)
        }
      end

        @data[:values] << parent
    end

    def add_bucket_list(buckets)
      @data[:values] << format_bucket_list(buckets)
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
      {
        label: bucket[:key],
        value: bucket[:doc_count],
        children: []
      }
    end
  end
end
