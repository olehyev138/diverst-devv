class GenericGraphsController < ApplicationController
  def group_population
    data = current_user.enterprise.groups.map { |g| g.members.count }
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
            xAxisTitle: 'ERG'
          },
          hasAggregation: false
        }
      }
      format.csv {
        strategy = Reports::GraphGeneric.new(title: 'Number of users ERG', categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_group_population.csv"
      }
    end
  end

  def segment_population
    data = current_user.enterprise.segments.map { |s| s.members.count }
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
        strategy = Reports::GraphGeneric.new(title: 'Number of users by segment', categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_segment_population.csv"
      }
    end
  end

  def events_created
    data = current_user.enterprise.groups.map { |g| g.initiatives.where('initiatives.created_at > ?', 1.month.ago).count }
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
            xAxisTitle: 'ERG',
            yAxisTitle: 'Nb of events'
          },
          hasAggregation: false
        }
      }
      format.csv {
        strategy = Reports::GraphGeneric.new(title: 'Number of events created ERG', categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_events_created.csv"
      }
    end
  end

  def messages_sent
    data = current_user.enterprise.groups.map { |g| g.messages.where('created_at > ?', 1.month.ago).count }
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
        strategy = Reports::GraphGeneric.new(title: 'Number of messages sent ERG', categories: categories, data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "graph_messages_sent.csv"
      }
    end
  end
end
