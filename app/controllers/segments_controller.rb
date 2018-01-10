class SegmentsController < ApplicationController
    before_action :set_segment, only: [:edit, :update, :destroy, :show, :export_csv]
    skip_before_action :verify_authenticity_token, only: [:create]
    after_action :verify_authorized

    layout 'erg_manager'

    def index
        authorize Segment
        @segments = policy_scope(Segment).includes(:members, :parent_segment).where(:segmentations => {:id => nil})
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
            redirect_to action: :index
        else
            flash[:alert] = "Your #{c_t(:segment)} was not created. Please fix the errors"
            render :edit
        end
    end

    def show
        authorize @segment

        @groups = current_user.enterprise.groups

        @group = @groups.find_by_id(params[:group_id])
        @segments = @segment.sub_segments.includes(:members)

        if @group.present?
            @members = segment_members_of_group(@segment, @group).uniq
        else
            @members = @segment.members.uniq
        end
    end

    def edit
        authorize @segment
    end

    def update
        authorize @segment
        if @segment.update(segment_params)
            flash[:notice] = "Your #{c_t(:segment)} was updated"
            redirect_to @segment
        else
            flash[:alert] = "Your #{c_t(:segment)} was not updated. Please fix the errors"
            render :edit
        end
    end

    def destroy
        authorize @segment
        @segment.destroy
        redirect_to action: :index
    end

    def export_csv
        authorize @segment, :show?

        if group = current_user.enterprise.groups.find_by_id(params[:group_id])
            users_ids = segment_members_of_group(@segment, group).map { |user| user.id }

            users = User.where(id: users_ids)
        else
            users = @segment.members
        end

        users_csv = User.to_csv users: users, fields: @segment.enterprise.fields
        send_data users_csv, filename: "#{@segment.name}.csv"
    end

    protected

    def segment_members_of_group(segment, group)
        segment.members.includes(:groups).select do |user|
            user.groups.include? group
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
