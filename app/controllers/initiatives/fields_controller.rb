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

        render json: {
          highcharts: [{
            name: @field.title,
            data: data
          }]
        }
      }
      format.csv {
        InitiativeFieldTimeSeriesDownloadJob.perform_later(current_user.id, @group.id, @field.id, params[:from], params[:to])
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  protected

  def set_group
    current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:initiative_id])
  end

  def set_field
    @field = @initiative.fields.find(params[:id])
  end
end
