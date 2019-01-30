class User::GroupsController < ApplicationController
    before_action :authenticate_user!

    layout 'user'

    def index
        @groups = current_user.enterprise.groups.order(:position).all_parents
    end

    def join
        @group = current_user.enterprise.groups.find(params[:id])
        return if policy(@group).is_a_member?

        UserGroup.create!(user_id: current_user.id, group_id: @group.id, accepted_member: @group.pending_users.disabled?)
        
        @group.save
    end
end
