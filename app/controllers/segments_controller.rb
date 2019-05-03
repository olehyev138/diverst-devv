class SegmentsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_segment, only: [:edit, :show, :export_csv, :update, :destroy]
  before_action :set_segments, only: [:index, :get_all_segments]

  layout 'erg_manager'

  def index
    authorize Segment

    respond_to do |format|
      format.html
      format.json { render json: SegmentDatatable.new(view_context, @segments) }
    end
  end

  def get_all_segments
    authorize Segment, :index?

    respond_to do |format|
      format.json { render json: @segments.map { |s| {id: s.id, text: s.name} }.as_json }
    end
  end

  def enterprise_segments
    authorize Segment
    @segments = policy_scope(Segment).all_parents
    respond_to do |format|
      format.html
      format.json { render json: EnterpriseSegmentDatatable.new(view_context, @segments) }
    end
  end

  def new
    authorize Segment
    @segment = current_user.enterprise.segments.new
    @segment.id = -1

    @segment.parent = Segment.find(params[:parent_id]) if params[:parent_id].present?

    render :show
  end

  def create
    authorize Segment

    @segment = current_user.enterprise.segments.new(segment_params)

    if @segment.save
      flash[:notice] = "Your #{c_t(:segment)} was created"
      track_activity(@segment, :create)
      redirect_to @segment
    else
      flash[:alert] = "Your #{c_t(:segment)} was not created. Please fix the errors"
      render :show
    end
  end

  def show
    authorize @segment

    @sub_segments = @segment.children
    @members = @segment.ordered_members

    respond_to do |format|
      format.html
      format.json { render json: SegmentMemberDatatable.new(view_context, @members) }
    end
  end

  def edit
    authorize @segment

    @sub_segments = @segment.children
    @members = @segment.ordered_members

    render :show
  end

  def update
    authorize @segment
    if @segment.update(segment_params)
      flash[:notice] = "Your #{c_t(:segment)} was updated"
      track_activity(@segment, :update)
      redirect_to @segment
    else
      flash[:alert] = "Your #{c_t(:segment)} was not updated. Please fix the errors"
      render :show
    end
  end

  def destroy
    authorize @segment
    track_activity(@segment, :destroy)
    @segment.destroy
    redirect_to action: :index
  end

  def export_csv
    authorize @segment, :show?
    SegmentMembersDownloadJob.perform_later(current_user.id, @segment.id, params[:group_id])
    flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
    redirect_to :back
  end

  def segment_status
    @segment = current_user.enterprise.segments.find(params[:id])
    authorize @segment, :show?

    respond_to do |format|
      format.json {
        render json: { status: @segment.job_status }
      }
    end
  end

  protected

  def set_segment
    @segment = current_user.enterprise.segments.find(params[:id])
  end

  def set_segments
    @segments = policy_scope(Segment).all_parents
  end

  def segment_params
    params
      .require(:segment)
      .permit(
        :name,
        :active_users_filter,
        :limit,
        :parent_id,
        field_rules_attributes: [
          :id,
          :field_id,
          :operator,
          :_destroy,
          values: []
        ],
        order_rules_attributes: [
          :id,
          :field,
          :operator,
          :_destroy,
        ],
        group_rules_attributes: [
          :id,
          :operator,
          :_destroy,
          group_ids: []
        ]
      )
  end
end
