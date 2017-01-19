class GenericGraphsController < ApplicationController
  def group_population
    render json: {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Number of users',
          data: current_user.enterprise.groups.map { |g| g.members.count }
        }],
        categories: current_user.enterprise.groups.map(&:name),
        xAxisTitle: 'ERG'
      },
      hasAggregation: false
    }
  end

  def segment_population
    render json: {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Number of users',
          data: current_user.enterprise.segments.map { |s| s.members.count }
        }],
        categories: current_user.enterprise.segments.map(&:name),
        xAxisTitle: 'Segment'
      },
      hasAggregation: false
    }
  end

  def events_created
    render json: {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Events created',
          data: current_user.enterprise.groups.map { |g| g.initiatives.where('initiatives.created_at > ?', 1.month.ago).count }
        }],
        categories: current_user.enterprise.groups.map(&:name),
        xAxisTitle: 'ERG',
        yAxisTitle: 'Nb of events'
      },
      hasAggregation: false
    }
  end

  def messages_sent
    render json: {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Messages sent',
          data: current_user.enterprise.groups.map { |g| g.messages.where('created_at > ?', 1.month.ago).count }
        }],
        categories: current_user.enterprise.groups.map(&:name),
        xAxisTitle: 'ERG',
        yAxisTitle: 'Nb of messages'
      },
      hasAggregation: false
    }
  end
end
