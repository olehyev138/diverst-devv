module Metrics
  module GroupMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def group_population(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = UserGroup.get_graph_builder
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)
      graph.formatter.title = "#{c_t(:erg)} Population"

      graph.query = graph.query.terms_agg(field: 'group.name', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      graph.query = add_scoped_group_filter(graph, 'group_id', scoped_groups)

      graph.formatter.parser.extractors[:y] = graph.formatter.parser.date_range(key: :doc_count)

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def initiatives_per_group(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = Initiative.get_graph_builder
      graph.set_enterprise_filter(field: 'pillar.outcome.group.enterprise_id', value: enterprise_id)
      graph.formatter.title = 'Events Created'

      graph.query = graph.query.terms_agg(field: 'pillar.outcome.group.name', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      graph.query = add_scoped_group_filter(graph, 'pillar.outcome.group.id', scoped_groups)

      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def messages_per_group(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = GroupMessage.get_graph_builder
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)
      graph.formatter.title = 'Messages Sent'

      graph.query = graph.query.terms_agg(field: 'group.name', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      graph.query = add_scoped_group_filter(graph, 'group_id', scoped_groups)

      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def views_per_group(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = View.get_graph_builder
      graph.set_enterprise_filter(value: enterprise_id)
      graph.formatter.title = "# Views per #{c_t(:erg)}"

      graph.query = graph.query.terms_agg(field: 'group.name', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      graph.query = add_scoped_group_filter(graph, 'group_id', scoped_groups)

      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def views_per_folder(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = View.get_graph_builder
      graph.set_enterprise_filter(value: enterprise_id)
      graph.formatter.title = '# Views per Folder'

      graph.query = graph.query.terms_agg(field: 'folder.id', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range) { |qq|
          qq.top_hits_agg
        }
      }

      graph.query = add_scoped_group_filter(graph, 'folder.group.id', scoped_groups)

      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)
      parser.extractors[:x] = parser.date_range { |p| p.top_hits { |pp| pp.custom(-> (e, _) {
                                                                                    return if e.blank? || e == 0

                                                                                    (e.dig(:folder, :group, :name) || 'Shared') + ' ' + e.dig(:folder, :name)
                                                                                  })
                                                      }
      }

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def views_per_resource(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = View.get_graph_builder
      graph.set_enterprise_filter(value: enterprise_id)
      graph.formatter.title = '# Views per Resource'

      graph.query = graph.query.terms_agg(field: 'resource.id', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range) { |qq|
          qq.top_hits_agg
        }
      }

      graph.query = add_scoped_group_filter(graph, 'resource.group.id', scoped_groups)

      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)
      parser.extractors[:x] = parser.date_range { |p| p.top_hits { |pp| pp.custom(-> (e, _) {
                                                                                    return if e.blank? || e == 0

                                                                                    (e.dig(:resource, :group, :name) || 'Shared') + ' ' + e.dig(:resource, :title)
                                                                                  })
                                                      }
      }

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def views_per_news_link(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = View.get_graph_builder
      graph.set_enterprise_filter(value: enterprise_id)
      graph.formatter.title = '# Views per News Link'

      graph.query = graph.query.terms_agg(field: 'news_feed_link.news_link.id', size: 10) { |q|
        q.date_range_agg(field: 'created_at', range: date_range) { |qq|
          qq.top_hits_agg
        }
      }

      graph.query = add_scoped_group_filter(graph, 'news_feed_link.group.id', scoped_groups)

      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)
      parser.extractors[:x] = parser.date_range { |p| p.top_hits { |pp| pp.custom(-> (e, _) {
                                                                                    return if e.blank? || e == 0

                                                                                    (e.dig(:news_feed_link, :group, :name) || 'Shared') +
                                                                                      ' ' + e.dig(:news_feed_link, :news_link, :title)
                                                                                  })
                                                      }
      }

      graph.formatter.add_elements(graph.search)

      graph.build
    end

    def growth_of_groups(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = UserGroup.get_graph_builder
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)

      graph.formatter.type = 'line'
      graph.formatter.title = "Growth of #{c_t(:erg).pluralize.capitalize}"

      parser = graph.formatter.parser
      parser.extractors[:y] = -> (_, args) { args[:total] }
      custom_parser = graph.get_new_parser
      custom_parser.extractors[:y] = custom_parser.date_range(key: :doc_count)

      scoped_groups = manage_group_scopes(scoped_groups)
      groups = scoped_groups.present? ? enterprise.groups.where(id: scoped_groups)
                                      : enterprise.groups
      groups.each do |group|
        graph.query = graph.query
          .filter_agg(field: 'group_id', value: group.id) { |q|
          q.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc') { |qq|
            qq.date_range_agg(field: 'created_at', range: date_range)
          }
        }

        # each group is a new series/line on our line graph
        total = 0
        graph.formatter.add_series(series_name: group.name)
        elements = graph.search

        elements.each { |e|
          total += custom_parser.parse(e)[:y]
          graph.formatter.add_element(e, total: total)
        }
      end

      graph.build
    end

    def growth_of_resources(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = Resource.get_graph_builder
      graph.set_enterprise_filter(field: 'folder.group.enterprise_id', value: enterprise_id)

      graph.formatter.type = 'line'
      graph.formatter.title = 'Growth of Resources'

      parser = graph.formatter.parser
      parser.extractors[:y] = -> (_, args) { args[:total] }
      custom_parser = graph.get_new_parser
      custom_parser.extractors[:y] = custom_parser.date_range(key: :doc_count)

      scoped_groups = manage_group_scopes(scoped_groups)
      groups = scoped_groups.present? ? enterprise.groups.all_parents.where(id: scoped_groups)
                                      : enterprise.groups.all_parents
      groups.each do |group|
        graph.query = graph.query
          .filter_agg(field: 'folder.group_id', value: group.id) { |q|
          q.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc') { |qq|
            qq.date_range_agg(field: 'created_at', range: date_range)
          }
        }

        total = 0
        graph.formatter.add_series(series_name: group.name)
        elements = graph.search

        elements.each { |e|
          total += custom_parser.parse(e)[:y]
          graph.formatter.add_element(e, total: total)
        }
      end

      graph.build
    end
  end
end
