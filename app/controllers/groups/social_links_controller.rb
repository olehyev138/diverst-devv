class Groups::SocialLinksController < ApplicationController

    before_action :authenticate_user!

    before_action :set_group
    before_action :set_social_link, only: [:destroy]

    layout 'erg'

    def new
        @social_link = @group.social_links.new
    end

    def create
        @social_link = @group.social_links.new(social_link_params)
        @social_link.author = current_user

        if @social_link.save
            redirect_to group_posts_path(@group)
        else
            flash[:alert] = "Your news was not created. Please fix the errors"
            render :edit
        end
    end

    def destroy
        @social_link.destroy
        flash[:notice] = "Your social link was removed."
        redirect_to group_posts_path(@group)
    end

    protected

    def set_group
        @group = current_user.enterprise.groups.find(params[:group_id])
    end

    def set_social_link
        @social_link = @group.social_links.find(params[:id])
    end

    def social_link_params
        params
            .require(:social_link)
            .permit(
                :url
            )
    end
end
