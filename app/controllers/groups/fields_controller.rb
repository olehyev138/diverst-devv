class Groups::FieldsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_field, only: [:time_series]
  after_action :verify_authorized

  layout 'plan'

  def time_series
    authorize @group, :show?

    respond_to do |format|
      format.json {
        from = Time.at(params[:from] / 1000) rescue nil
        to = Time.at(params[:to] / 1000) rescue nil
        data = @group.highcharts_history(
          field: @field,
          from: from || 1.year.ago,
          to: to || Time.current + 1.day
        )

        render json: {
          highcharts: [{
            name: @field.title,
            data: data
          }]
        }
      }
      format.csv {
        GroupFieldTimeSeriesDownloadJob.perform_later(current_user.id, @group.id, @field.id)
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_field
    @field = @group.fields.find(params[:id])
  end
end
