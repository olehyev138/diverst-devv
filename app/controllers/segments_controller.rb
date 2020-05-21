class SegmentsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_segment, only: [:edit, :show, :export_csv, :update, :destroy]
  before_action :set_segments, only: [:index, :get_all_segments]
  after_action :visit_page, only: [:index, new, :show, :edit]

  layout 'erg_manager'

  def index
    authorize Segment

    respond_to do |format|
      format.html
      format.json { render json: SegmentDatatable.new(view_context, @segments) }
    end
  end

  def get_paginated_segments
    authorize Segment, :index?

    respond_to do |format|
      format.json {
        segments = current_user.enterprise.segments.all_parents
                     .order(:id)
                     .joins('LEFT JOIN groups as children ON segments.id = children.parent_id')
                     .uniq
                     .where('LOWER(segments.name) like ? OR LOWER(children.name) like ?', "%#{search_params[:term]}%", "%#{search_params[:term]}%")
                     .page(search_params[:page])
                     .per(search_params[:limit])
                     .includes(:children)

        segments_hash = segments.as_json(
          only: [:id, :name, :parent_id],
          include: {
            children: {
              only: [:id, :name, :parent_id]
            }
          }
        )

        render json: {
          total_pages: segments.total_pages,
          segment_text: c_t(:segment),
          segment_text_pluralized: c_t(:segment).pluralize,
          segments: segments_hash
        }
      }
    end
  end

  def get_all_segments
    authorize Segment, :index?

    respond_to do |format|
      format.json { render json: @segments.map { |s| { id: s.id, text: s.name } }.as_json }
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

    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
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

  def search_params
    params.permit(:page, :limit, :term, ids: [])
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Segment List'
    when 'new'
      'Segment Creation'
    when 'show'
      "Segment: #{@segment.to_label}"
    when 'edit'
      "Segment Edit: #{@segment.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
