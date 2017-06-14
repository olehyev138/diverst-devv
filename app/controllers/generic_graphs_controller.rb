class GenericGraphsController < ApplicationController
  def group_population
    data = current_user.enterprise.groups.map { |g| g.members.active.count }
    categories = current_user.enterprise.groups.map(&:name)

    respond_to do |format|
      format.json {
        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Number of users',
              data: data
            }],
            categories: categories,
            xAxisTitle: "#{ c_t(:erg) }"
          },
          hasAggregation: false
        }
      }
      format.csv {
        strategy = Reports::GraphStatsGeneric.new(title: "Number of users #{ c_t(:erg) }", categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_group_population.csv"
      }
    end
  end

  def segment_population
    data = current_user.enterprise.segments.map { |s| s.members.active.count }
    categories = current_user.enterprise.segments.map(&:name)

    respond_to do |format|
      format.json {
        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Number of users',
              data: data
            }],
            categories: categories,
            xAxisTitle: 'Segment'
          },
          hasAggregation: false
        }
      }
      format.csv {
        strategy = Reports::GraphStatsGeneric.new(title: 'Number of users by segment', categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_segment_population.csv"
      }
    end
  end

  def events_created
    data = current_user.enterprise.groups.map do |g|
      g.initiatives.joins(:owner)
        .where('initiatives.created_at > ? AND users.active = ?', 1.month.ago, true).count
    end
    categories = current_user.enterprise.groups.map(&:name)

    respond_to do |format|
      format.json{
        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Events created',
              data: data
            }],
            categories: categories,
            xAxisTitle: "#{ c_t(:erg) }",
            yAxisTitle: 'Nb of events'
          },
          hasAggregation: false
        }
      }
      format.csv {
        strategy = Reports::GraphStatsGeneric.new(title: "Number of events created #{ c_t(:erg) }", categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_events_created.csv"
      }
    end
  end

  def messages_sent
    data = current_user.enterprise.groups.map do |g|
      g.messages.joins(:owner)
        .where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count
    end
    categories = current_user.enterprise.groups.map(&:name)

    respond_to do |format|
      format.json {
        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Messages sent',
              data: data
            }],
            categories: categories,
            xAxisTitle: 'ERG',
            yAxisTitle: 'Nb of messages'
          },
          hasAggregation: false
        }
      }
      format.csv {
        strategy = Reports::GraphStatsGeneric.new(title: "Number of messages sent #{ c_t(:erg) }", categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_messages_sent.csv"
      }
    end
  end
end
