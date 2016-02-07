class SegmentsController < ApplicationController
  before_action :set_segment, only: [:edit, :update, :destroy, :show, :export_csv]
  skip_before_action :verify_authenticity_token, only: [:create]

  layout 'erg_manager'

  def index
    @segments = current_user.enterprise.segments
  end

  def new
    @segment = current_user.enterprise.segments.new
  end

  def create
    @segment = current_user.enterprise.segments.new(segment_params)

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
    users_csv = User.to_csv users: @segment.members, fields: @segment.enterprise.fields
    send_data users_csv, filename: "#{@segment.name}.csv"
  end

  protected

  def set_segment
    @segment = current_user.enterprise.segments.find(params[:id])
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
