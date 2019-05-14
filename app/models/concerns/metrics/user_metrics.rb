module Metrics
  module UserMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def user_change_percentage
      # Growth of user population

      from_date = 6.months.ago
      to_date = Time.now

      # these comparison operators are not wrong, 1) get total *as of* the from_date
      #                                           2) get total *as of* the to_date
      from_date_total = enterprise.users.where('created_at <= ?', from_date).count.to_f
      to_date_total = enterprise.users.where('created_at <= ?', to_date).count.to_f

      get_change_percentage(from_date_total, to_date_total)
    end

    def user_groups_intersection(group_ids)
      # get list of member ids for each group
      members_per_group = Group.find(group_ids).map { |g| g.members.map(&:id) }

      # run an intersection operation on every member list
      # ie get all member ids that are common between all groups
      common_member_ids = members_per_group.reduce { |result, element| result & element }

      # map member ids back to activerecord objects
      enterprise.users.where('id in (?)', common_member_ids)
    end

    def group_memberships
      from_date = 6.months.ago

      UserGroup.joins(:user)
               .where('enterprise_id = ? AND user_groups.created_at >= ?', enterprise_id, from_date)
               .count
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
