class GroupCategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:update_all_groups]

  layout :resolve_layout

  def index
    authorize Group
    @parent = Group.find(params[:parent_id].to_i)
    @group = Group.find(params[:group_id].to_i)
    @categories = GroupCategory.all
  end

  def new
  	authorize Group
    @group = Group.find(params[:group_id].to_i)

    @group_category_type = GroupCategoryType.new
  end

  def create
    authorize Group
    @group = Group.find(params[:group_category_type][:group_id].to_i)
    @group_category_type = GroupCategoryType.new(category_type_params)


    if @group_category_type.save
      flash[:notice] = "you just created a category named #{@group_category_type.name}"
      redirect_to group_categories_url(parent_id: @group.parent_id, group_id: @group.id)
    else
      flash[:alert] = "something went wrong. Please check errors."
      render :new
    end
  end

  def update_all_groups
    params[:children].each do |child|
      next if Group.find(child[0].to_i).group_category_id == child[1][:group_category_id].to_i
      Group.find(child[0].to_i).update(group_category_id: child[1][:group_category_id].to_i, group_category_type_id: GroupCategory.find(child[1][:group_category_id].to_i).group_category_type_id)
    end

    # find parent group and update with association with group category type
    @parent = Group.find(params[:children].first[0].to_i).parent 
    @parent.update(group_category_type_id: @parent.children.first.group_category_type_id)

    flash[:notice] = "Categorization successful"
    redirect_to :back
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
