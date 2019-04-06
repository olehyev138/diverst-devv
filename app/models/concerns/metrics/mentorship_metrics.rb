module Metrics
  module MentorshipMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def user_mentorship_interest_per_group
      graph = UserGroup.get_graph_builder
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)
      graph.formatter.title = 'Users interested in Mentorship'

      graph.query = graph.query.bool_filter_agg { |qq| qq.terms_agg(field: 'group.name') }
      graph.query.add_filter_clause(field: 'user.active', value: true, bool_op: :must)
      graph.query.add_filter_clause(field: 'user.mentor', value: true, bool_op: :should)
      graph.query.add_filter_clause(field: 'user.mentee', value: true, bool_op: :should)

      graph.drilldown_graph(parent_field: 'group.parent.name')

      graph.build
    end

    def mentoring_sessions_per_creator(date_range)
      date_range = parse_date_range(date_range)

      graph = MentoringSession.get_graph_builder
      graph.set_enterprise_filter(field: 'creator.enterprise_id', value: enterprise_id)
      graph.formatter.title = 'Mentoring Sessions'

      graph.query = graph.query.bool_filter_agg { |qq|
        qq.terms_agg(field: 'creator.last_name') { |qqq|
          qqq.date_range_agg(field: 'created_at', range: date_range)
        }
      }

      graph.query.add_filter_clause(field: 'creator.active', value: true, bool_op: :must)
      parser = graph.formatter.parser
      parser.extractors[:y] = parser.date_range(key: :doc_count)

      graph.formatter.add_elements(graph.search)

      graph.build
    end

    def mentoring_interests
      graph = MentorshipInterest.get_graph_builder
      graph.set_enterprise_filter(field: 'user.enterprise_id', value: enterprise_id)
      graph.formatter.title = 'Mentoring Interests'

      graph.query = graph.query.terms_agg(field: 'mentoring_interest.name')
      graph.formatter.add_elements(graph.search)

      graph.build
    end
  end
end
