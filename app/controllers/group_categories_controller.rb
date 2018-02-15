class GroupCategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  layout :resolve_layout

  def index
    authorize Group
    @parent = Group.find(params[:parent_id])
    @categories = GroupCategory.all
  end

  def show
  end

  def new
  	authorize Group
    @group = Group.find(params[:group_id].to_i)

    @group_category_type = GroupCategoryType.new
  end

  def create
    authorize Group
    @group = Group.find(params[:group_category_type][:group_id].to_i)
    @category_type = GroupCategoryType.new(category_type_params)


    if @category_type.save
      flash[:notice] = "you just created a category named #{@category_type.name}"
      redirect_to group_categories_url(parent_id: @group.parent_id)
    else
      flash[:alert] = "something went wrong. Please check errors."
      render :new
    end
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

  def category_type_params
    params.require(:group_category_type)
      .permit(:name, :category_names)
  end
end
