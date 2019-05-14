module Metrics
  module CampaignMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def contributions_per_erg(campaign)
      graph = Answer.get_graph_builder
      graph.set_enterprise_filter(field: 'author.enterprise_id', value: campaign.enterprise_id)
      graph.formatter.title = 'Contributions per erg'
      graph.formatter.type = 'pie'

      graph.query = graph.query.filter_agg(field: 'question.campaign_id', value: campaign.id) { |q|
        q.terms_agg(field: 'contributing_group.name')
      }

      graph.formatter.add_elements(graph.search)
      graph.build
    end

    def top_performers(campaign)
      # Total votes for all answers per user

      graph = Answer.get_graph_builder
      graph.set_enterprise_filter(field: 'author.enterprise_id', value: campaign.enterprise_id)
      graph.formatter.title = 'Total votes per user'

      graph.query = graph.query.filter_agg(field: 'question.campaign_id', value: campaign.id) { |q|
        q.terms_agg(field: 'author.id') { |qq| qq.sum_agg(field: 'upvote_count') }
      }

      parser = graph.formatter.parser
      parser.extractors[:x] = -> (e, _) { User.find(e[:key]).name }
      parser.extractors[:y] = parser.sum { |p| p.custom(-> (e, _) { e.round }) }

      graph.formatter.add_elements(graph.search)
      graph.build
    end
  end
end
