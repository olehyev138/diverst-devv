class Initiatives::FieldsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_initiative
  before_action :set_field
  after_action :verify_authorized

  layout 'plan'

  def time_series
    authorize Initiative, :index?

    respond_to do |format|
      format.json {
        from = Time.at(params[:from] / 1000) rescue nil
        to = Time.at(params[:to] / 1000) rescue nil
        data = @initiative.highcharts_history(
          field: @field,
          from: from || 1.year.ago,
          to: to || Time.current + 1.day
        )

        data = data.select do |pair|
          pair[1].present?
        end

        data.sort_by! { |pair| pair[0] }

        values = data.map do |pair|
          { x: pair[0], y: pair[1], children: {} }
        end

        render json: {
          title: @field.title,
          type: 'line',
          x_label: nil,
          y_label: nil,
          series: [{
                     key: @field.title,
                     values: values
                   }]
        }
      }
      format.csv {
        InitiativeFieldTimeSeriesDownloadJob.perform_later(current_user.id, @initiative.id, @field.id, params[:from], params[:to])
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  def joined_time_series
    authorize Initiative, :index?

    respond_to do |format|
      format.json {
        from = Time.at(params[:from] / 1000) rescue nil
        to = Time.at(params[:to] / 1000) rescue nil
        data = @initiative.highcharts_history_all_fields(
          fields: @initiative.fields,
          from: from || 1.year.ago,
          to: to || Time.current + 1.day
        )

        render json: {
          title: 'Metrics',
          type: 'line',
          x_label: nil,
          y_label: nil,
          series: data
        }
      }
      format.csv {
        InitiativeFieldTimeSeriesDownloadJob.perform_later(current_user.id, @initiative.id, @field.id, params[:from], params[:to])
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:initiative_id])
  end

  def set_field
    @field = @initiative.fields.find(params[:id]) rescue nil
  end
end
