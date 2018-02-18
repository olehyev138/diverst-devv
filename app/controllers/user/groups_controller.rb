class User::GroupsController < ApplicationController
    before_action :authenticate_user!

    layout 'user'

    def index
        @groups = current_user.enterprise.groups.non_private
    end

    def join
        @group = current_user.enterprise.groups.find(params[:id])
        return if @group.members.include? current_user
        @group.members << current_user
        @group.save
    end
end
