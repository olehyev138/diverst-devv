class SegmentsController < ApplicationController
  before_action :set_segment, only: [:edit, :update, :destroy, :show, :export_csv]
  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :verify_authorized

  layout 'erg_manager'

  def index
    authorize Segment
    @segments = policy_scope(Segment)
  end

  def new
    authorize Segment
    @segment = current_user.enterprise.segments.new
  end

  def create
    authorize Segment
    @segment = current_user.enterprise.segments.new(segment_params)

    if @segment.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    authorize @segment
    if @segment.update(segment_params)
      redirect_to @segment
    else
      render :edit
    end
  end

  def destroy
    authorize @segment
    @segment.destroy
    redirect_to action: :index
  end

  def export_csv
    authorize @segment, :show
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
