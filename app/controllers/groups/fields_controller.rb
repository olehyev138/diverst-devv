class Groups::FieldsController < ApplicationController
  before_action :set_group
  before_action :set_field, only: [:time_series]
  after_action :verify_authorized

  layout 'plan'

  def time_series
    authorize @group, :show?
    from = Time.at(params[:from] / 1000) rescue nil
    to = Time.at(params[:to] / 1000) rescue nil
    data = @group.highcharts_history(
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
        strategy = Reports::GraphTimeseriesGeneric.new(
          data: data
        )
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "metrics#{ @field.id }.csv"
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
