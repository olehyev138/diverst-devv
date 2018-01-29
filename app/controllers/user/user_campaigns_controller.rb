class User::UserCampaignsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_campaign, only: [:edit, :update, :destroy, :show]

    layout 'user'

    def index
        @campaigns = current_user.campaigns.published.order(created_at: :desc)
    end

    # MISSING TEMPLATE
    def show
        @questions = @campaign.questions.order(created_at: :desc).page(params[:page]).per(10)
    end

    def update
        if @campaign.update(campaign_params)
            flash[:notice] = "Your campaign was updated"
            redirect_to @campaign
        else
            flash[:alert] = "Your campaign was not updated. Please fix the errors"
            render :edit #NOTE: edit template does not work
        end
    end

    def destroy
        @campaign.destroy
        redirect_to action: :index
    end

    protected

    def set_campaign
        if current_user
          @campaign = current_user.enterprise.campaigns.published.find(params[:id])
        else
          user_not_authorized
        end
    end

    def campaign_params
        params
            .require(:campaign)
            .permit(
                :title,
                :description,
                :start,
                :end,
                :nb_invites,
                group_ids: [],
                segment_ids: [],
                questions_attributes: [
                    :id,
                    :_destroy,
                    :title,
                    :description
                ]
            )
    end
end
