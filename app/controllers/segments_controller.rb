class SegmentsController < ApplicationController
    before_action :authenticate_user!
    after_action :verify_authorized
    before_action :set_segment, only: [:edit, :show, :export_csv, :update, :destroy]

    layout 'erg_manager'

    def index
        authorize Segment
        @segments = policy_scope(Segment).includes(:parent_segment).where(:segmentations => {:id => nil}).distinct

        respond_to do |format|
            format.html
            format.json { render json: SegmentDatatable.new(view_context, @segments) }
        end
    end

    def new
        authorize Segment
        @segment = current_user.enterprise.segments.new
    end

    def create
        authorize Segment
        @segment = current_user.enterprise.segments.new(segment_params)

        if @segment.save
            flash[:notice] = "Your #{c_t(:segment)} was created"
            track_activity(@segment, :create)
            redirect_to action: :index
        else
            flash[:alert] = "Your #{c_t(:segment)} was not created. Please fix the errors"
            render :edit
        end
    end

    def show
        authorize @segment

        @groups = current_user.enterprise.groups
        
        @segments = @segment.sub_segments.includes(:members)

        members
        
        respond_to do |format|
            format.html
            format.json { render json: SegmentMemberDatatable.new(view_context, @members) }
        end
    end

    def edit
        authorize @segment
    end

    def update
        authorize @segment
        if @segment.update(segment_params)
            flash[:notice] = "Your #{c_t(:segment)} was updated"
            track_activity(@segment, :update)
            redirect_to @segment
        else
            flash[:alert] = "Your #{c_t(:segment)} was not updated. Please fix the errors"
            render :edit
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
        flash[:notice] = "Please check your email in a couple minutes"
        redirect_to :back
    end
    
    protected

    def members
        if !params[:group_id].blank?
            @group = current_user.enterprise.groups.find_by_id(params[:group_id])
            @members = policy_scope(User).joins(:segments, :groups).where(:segments => {:id => @segment.id}, :groups => {:id => params[:group_id]}).limit(params[:limit] || 25).distinct
            
        else
            @members = policy_scope(User).joins(:segments).where(:segments => {:id => @segment.id}).limit(params[:limit] || 25).distinct
        end
    end

    def set_segment
        @segment = current_user.enterprise.segments.find(params[:id])
    end

    def segment_params
        params
            .require(:segment)
            .permit(
                :name,
                :active_users_filter,
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
