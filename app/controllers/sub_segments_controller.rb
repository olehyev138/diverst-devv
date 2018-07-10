class SubSegmentsController < ApplicationController
    before_action :set_segment
    skip_before_action :verify_authenticity_token, only: [:create]
    after_action :verify_authorized

    layout 'erg_manager'

    def new
        authorize Segment
        @sub_segment = @segment.sub_segments.new
    end

    def create
        authorize Segment
        @sub_segment = @segment.sub_segments.new(segment_params)
        @sub_segment.enterprise_id = @segment.enterprise_id

        if @segment.save
            flash[:notice] = "Your sub-segment was created"
            redirect_to @segment
        else
            flash[:alert] = "Your sub-segment was not created. Please fix the errors"
            redirect_to :back
        end
    end

    private

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

    def set_segment
        @segment = Segment.find(params[:segment_id])
    end
end
