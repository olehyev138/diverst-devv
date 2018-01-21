class User::UserGroupsController < ApplicationController
    before_action :authenticate_user!

    layout 'user'

    def edit
        @user_groups = current_user.
            user_groups.
            joins(:group).
            order("groups.name asc").
            includes(:group)
    end

    def update
        has_error = false
        params[:user_groups].each do |id, parameters|
            user_group = UserGroup.find(id)
            unless user_group.update(user_group_params(parameters))
                flash[:alert] = "Your preferences were not updated. Please fix the errors"
                redirect_to action: :edit
                has_error = true
                break
            end
        end
        return if has_error
        flash[:notice] = "Your preferences were updated"
        redirect_to action: :edit
    end

    private

    def user_group_params(parameters)
        parameters.permit(:notifications_frequency, :notifications_date)
    end
end
