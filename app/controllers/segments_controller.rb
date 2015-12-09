class SegmentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_segment, only: [:edit, :update, :destroy, :show, :export_csv]
  skip_before_action :verify_authenticity_token, only: [:create]

  layout "global_settings"

  def index
    @segments = current_admin.enterprise.segments
  end

  def new
    @segment = current_admin.enterprise.segments.new
  end

  def create
    @segment = current_admin.enterprise.segments.new(segment_params)

    if @segment.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    if @segment.update(segment_params)
      redirect_to @segment
    else
      render :edit
    end
  end

  def destroy
    @segment.destroy
    redirect_to action: :index
  end

  def export_csv
    employees_csv = Employee.to_csv employees: @segment.members, fields: @segment.enterprise.fields
    send_data employees_csv, filename: "#{@segment.name}.csv"
  end

  protected

  def set_segment
    @segment = current_admin.enterprise.segments.find(params[:id])
  end

  def segment_params
    params
    .require(:segment)
    .permit(
      :name,
      rules_attributes: [
        :id,
        :_destroy,
        :field_id,
        :operator,
        values: []
      ]
    )
  end
end
