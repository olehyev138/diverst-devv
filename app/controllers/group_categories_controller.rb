class GroupCategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:update_all_groups, :view_all]

  layout :resolve_layout

  def index
    authorize Group
    @parent = Group.find(params[:parent_id].to_i)
    @categories = GroupCategory.all
  end

  def new
  	authorize Group
    @group_category_type = GroupCategoryType.new
  end

  def create
    authorize Group
    @group_category_type = GroupCategoryType.new(category_type_params)


    if @group_category_type.save
      flash[:notice] = "you just created a category named #{@group_category_type.name}"
      redirect_to groups_url
    else
      flash[:alert] = "something went wrong. Please check errors."
      render :new
    end
  end

  def update_all_groups
    params[:children].each do |child|
      next if Group.find(child[0].to_i).group_category_id == child[1][:group_category_id].to_i
      Group.find(child[0].to_i).update(group_category_id: child[1][:group_category_id].to_i)
    end

    flash[:notice] = "Categorization successful"
    redirect_to groups_url
  end

  def view_all
    @category_types = GroupCategoryType.all
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

  def category_type_params
    params.require(:group_category_type)
      .permit(:name, :category_names)
  end
end
