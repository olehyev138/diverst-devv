class Initiatives::FieldsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_initiative
  before_action :set_field
  after_action :verify_authorized

  layout 'plan'

  def time_series
    authorize Initiative, :index?

    from = Time.at(params[:from] / 1000) rescue nil
    to = Time.at(params[:to] / 1000) rescue nil
    data = @initiative.highcharts_history(
      field: @field,
      from: from || 1.year.ago,
      to: to || Time.current + 1.day
    )

    respond_to do |format|
      format.json {
        render json: {
          highcharts: [{
            name: @field.title,
            data: data
          }]
        }
      }
      format.csv {
        strategy = Reports::GraphTimeseriesGeneric.new(data: data)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "metrics#{ @field.id }.csv"
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
