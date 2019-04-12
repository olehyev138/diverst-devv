module Metrics
  module UserMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def user_change_percentage
      # Growth of user population over last year

      from_date = 6.months.ago
      to_date = Time.now

      # these comparison operators are not wrong, 1) get total *as of* the from_date
      #                                           2) get total *as of* the to_date
      from_date_total = enterprise.users.where('created_at <= ?', from_date).count.to_f
      to_date_total = enterprise.users.where('created_at <= ?', to_date).count.to_f

      get_change_percentage(from_date_total, to_date_total)
    end

    def user_groups_intersection(group_ids)
      # Find all users that are in _all_ groups passed in group_ids
      # This is passed to Datatables which _requires_ an ActiveRecord object
      #   - therefore we cannot use es and we cannot pass an array

      group_ids = group_ids.map(&:to_i)
      user_ids = []

      enterprise.users.each do |u|
        user_ids << u.id if (group_ids - u.user_groups.pluck(:group_id)).empty?
      end

      enterprise.users.where('id in (?)', user_ids)
    end

    def group_memberships
      from_date = 6.months.ago

      UserGroup.joins(:user)
               .where('enterprise_id = ? AND user_groups.created_at >= ?', enterprise_id, from_date)
               .count
    end

    def users_per_group
      graph = UserGroup.get_graph_builder
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)
      graph.formatter.type = 'bar'
      graph.formatter.title = "User population per group"

      graph.query = graph.query.terms_agg(field: 'group.name')
      graph.drilldown_graph(parent_field: 'group.parent.name')

      graph.build
    end

    def users_per_segment
      graph = UsersSegment.get_graph_builder
      graph.set_enterprise_filter(field: 'segment.enterprise_id', value: enterprise_id)
      graph.formatter.title = "#{c_t(:segment).capitalize} Population"

      graph.query = graph.query.terms_agg(field: 'segment.name')
      graph.drilldown_graph(parent_field: 'segment.parent.name')

      graph.build
    end

    def user_growth(date_range_str)
      date_range = parse_date_range(date_range_str)

      graph = User.get_graph_builder
      graph.set_enterprise_filter(value: enterprise_id)
      graph.formatter.type = 'line'
      graph.formatter.title = 'Growth of employees'

      graph.query = graph.query.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc') { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      parser = graph.formatter.parser
      custom_parser = graph.get_new_parser
      parser.extractors[:y] = -> (_, args) { args[:total] }
      custom_parser.extractors[:count] = custom_parser.date_range(key: :doc_count)

      total = 0
      elements = graph.search
      graph.formatter.add_series

      elements.each { |e|
        total += custom_parser.parse(e)[:count]
        graph.formatter.add_element(e, total: total)
      }

      graph.build
    end
  end
end
