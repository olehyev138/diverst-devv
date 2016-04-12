class Groups::FieldsController < ApplicationController
  before_action :set_group
  before_action :set_field, only: [:time_series]
  after_action :verify_authorized

  layout 'plan'

  def time_series
    authorize @group, :show?

    highcharts_data = @group.highcharts_history(
      field: @field,
      from: Time.at(params[:from].to_i / 1000) || 1.year.ago,
      to: Time.at(params[:to].to_i / 1000) || Time.current
    )

    render json: highcharts_data
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_field
    @field = @group.fields.find(params[:id])
  end
end
