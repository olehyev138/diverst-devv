class GroupCategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  layout :resolve_layout

  helper ApplicationHelper

  def index
  end

  def show
  end

  def new
  	authorize Group
  	@group = Group.find(params[:group_id].to_i)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end


  private

  def resolve_layout
  	case action_name
  	when 'show'
  		'erg'
  	when 'metrics'
  		'plan'
  	when 'edit_fields', 'plan_overview', 'close_budgets'
  		'plan'
  	else
  		'erg_manager'
  	end
  end

  def set_group
  	current_user ? @group = current_user.enterprise.groups.find(params[:id]) : user_not_authorized
  end

  def group_category_params
        params.require(:group_category).permit(:name)
    end
end
