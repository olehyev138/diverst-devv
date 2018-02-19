class GroupCategoryTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update]
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
    @group_category_type.enterprise_id = current_user.enterprise.id


    if @group_category_type.save
      flash[:notice] = "you just created a category named #{@group_category_type.name}"
      redirect_to groups_url
    else
      flash[:alert] = "something went wrong. Please check errors."
      render :new
    end
  end

  def edit
    authorize Group
  end


  def update
    authorize Group
    if @category.update(category_params)
      flash[:notice] = "update category name"
      redirect_to view_all_group_categories_url
    else 
      flash[:alert] = "something went wrong. please fix errors"
      render 'edit'
    end
  end

  def update_all_groups
    params[:children].each do |child|
      next if Group.find(child[0].to_i).group_category_id == child[1][:group_category_id].to_i
      Group.find(child[0].to_i).update(group_category_id: child[1][:group_category_id].to_i)
    end

    flash[:notice] = "Categorization successful"
    redirect_to :back
  end

  def view_all
    @categories = current_user.enterprise.group_categories
    @category_types = current_user.enterprise.group_category_types
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
      .permit(:name, :enterprise_id, :category_names)
  end

  def category_params
    params.require(:group_category).permit(:name)
  end

  def set_category
    @category = current_user.enterprise.group_categories.find(params[:id])
  end
end
