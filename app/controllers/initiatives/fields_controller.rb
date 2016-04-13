class Initiatives::FieldsController < ApplicationController
  before_action :set_group
  before_action :set_initiative
  before_action :set_field
  after_action :verify_authorized

  layout 'plan'

  def time_series
    authorize Initiative, :index?

    highcharts_data = @initiative.highcharts_history(
      field: @field,
      from: Time.at(params[:from].to_i / 1000) || 1.year.ago,
      to: Time.at(params[:to].to_i / 1000) || Time.current
    )

    render json: {
      highcharts: [{
        name: @field.title,
        data: highcharts_data
      }]
    }
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:initiative_id])
  end

  def set_field
    @field = @initiative.fields.find(params[:id])
  end

  def field_params
    params
      .require(:initiative_field)
      .permit(
        :description,
        :amount
      )
  end
end
