class GenericGraphsController < ApplicationController
    include ActionView::Helpers::JavaScriptHelper

    before_action :authenticate_user!

    def group_population
        data = current_user.enterprise.groups.where(:parent_id => nil).map { |g|
            {
                y: g.members.active.count,
                name: g.name,
                drilldown: g.name
            }
        }
        drilldowns = current_user.enterprise.groups.includes(:children).where(:parent_id => nil).map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.members.active.count]}
            }
        }
        categories = current_user.enterprise.groups.map{ |g| g.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: 'Number of users',
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               categories: categories,
                               xAxisTitle: "#{c_t(:erg)}"
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of users #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_group_population.csv"
            }
        end
    end

    def segment_population
        segments = current_user.enterprise.segments.includes(:parent).where(:segmentations => {:parent_id => nil})

        data = segments.map { |s|
            {
                y: s.members.active.count,
                name: s.name,
                drilldown: s.name
            }
        }
        drilldowns = segments.includes(:sub_segments).map { |s|
            {
                name: s.name,
                id: s.name,
                data: s.sub_segments.map {|sub| [sub.name, sub.members.active.count]}
            }
        }
        categories = segments.map{ |s| s.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   name: 'Number of users',
                                   colorByPoint: true,
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               categories: categories,
                               xAxisTitle: c_t(:segment)
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of users by #{c_t(:badge)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_segment_population.csv"
            }
        end
    end

    def events_created
        data = current_user.enterprise.groups.where(:parent_id => nil).map do |g|
            {
                y: g.initiatives.joins(:owner)
                    .where('initiatives.created_at > ? AND users.active = ?', 1.month.ago, true).count,
                name: g.name,
                drilldown: g.name
            }
        end
        
        drilldowns = current_user.enterprise.groups.includes(:children).where(:parent_id => nil).map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.initiatives.joins(:owner)
                    .where('initiatives.created_at > ? AND users.active = ?', 1.month.ago, true).count]}
            }
        }
        
        categories = current_user.enterprise.groups.map{ |g| g.name }

        respond_to do |format|
            format.json{
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: 'Events created',
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               categories: categories,
                               xAxisTitle: "#{c_t(:erg)}",
                               yAxisTitle: 'Nb of events'
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of events created #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_events_created.csv"
            }
        end
    end

    def messages_sent
        data = current_user.enterprise.groups.where(:parent_id => nil).map do |g|
            {
                y: g.messages.joins(:owner)
                    .where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count,
                name: g.name,
                drilldown: g.name
            }
        end
        
        drilldowns = current_user.enterprise.groups.includes(:children).where(:parent_id => nil).map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.messages.joins(:owner)
                    .where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count]}
            }
        }
        
        categories = current_user.enterprise.groups.map{ |g| g.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: 'Messages sent',
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               categories: categories,
                               xAxisTitle: 'ERG',
                               yAxisTitle: 'Nb of messages'
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of messages sent #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_messages_sent.csv"
            }
        end
    end
end
