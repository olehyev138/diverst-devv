class User::GroupsController < ApplicationController
    before_action :authenticate_user!

    layout 'user'

    def index
        @groups = current_user.enterprise.groups.order(:position).all_parents
    end

    def join
        @group = current_user.enterprise.groups.find(params[:id])
        return if policy(@group).is_a_member?
        @group.members << current_user
        @group.save
    end
end
