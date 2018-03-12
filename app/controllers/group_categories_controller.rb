class GroupCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  layout :resolve_layout

  def index
    authorize Group

    @parent = Group.find(params[:parent_id].to_i)
    @categories = current_user.enterprise.group_categories
  end

  def new
  	authorize Group
    @parent = Group.find(params[:parent_id].to_i) if !params[:parent_id].to_i.zero?
    @group_category_type = current_user.enterprise.group_category_types.new
  end

  def create
    authorize Group

    @group_category_type = current_user.enterprise.group_category_types.new(category_type_params)
    @parent = Group.find(params[:group_category_type][:parent_id].to_i) if !params[:group_category_type][:parent_id].to_i.zero?

    if @group_category_type.save
      flash[:notice] = "You just created a category named #{@group_category_type.name}"

      if @parent
        redirect_to group_categories_url(parent_id: @parent.id)
      else
        redirect_to view_all_group_categories_url
      end
    else
      flash.now[:alert] = "Something went wrong. Please check errors."
      render :new
    end
  end

  def edit
    authorize Group
  end


  def update
    authorize Group

    if @category.update(category_params)
      flash[:notice] = "Update category name"
      redirect_to view_all_group_categories_url
    else
      flash.now[:alert] = "Something went wrong. please fix errors"
      render 'edit'
    end
  end

  def destroy
    authorize Group

    @category.destroy
    flash[:notice] = "Category successfully removed."
    redirect_to :back
  end

  def update_all_sub_groups
    authorize Group

    if all_incoming_labels_are_none?

      categorize_sub_groups
      flash[:notice] = "Nothing happened"
      redirect_to :back

    else
      # 2. If at least one label != none;
      # a. check each label's category type, all labels MUST BE OF ONE CATEGORY TYPE; if not, reject due to inconsistent
      # labels coming as params.
      # b. if a. passes, i.e all labels are of ONE category type, allow categorization. The assumption here is that
      #  the user wants a new category type submitting labels consistent with each other

     categorize_sub_groups

      flash[:notice] = "Categorization successful"
      redirect_to :back
    end
  end

  def view_all
    authorize Group
    @categories = current_user.enterprise.group_categories
    @category_types = current_user.enterprise.group_category_types
  end


  private

  def categorize_sub_groups
     # check params to avoid update of Group object with 0 value
    params[:children].any? do |child|
        if child[1][:group_category_id] != ""
          @group_category_id = child[1][:group_category_id].to_i
           break;
        end
      end

      # update sub groups with chosen group_category_id and group_category_type_id
      params[:children].each do |child|
        next if Group.find(child[0]).group_category_id == child[1][:group_category_id].to_i
        Group.find(child[0]).update(skip_label_consistency_check: true,
          group_category_id: child[1][:group_category_id].to_i.zero? ? nil : child[1][:group_category_id].to_i,
          group_category_type_id: @group_category_id.nil? ? nil : GroupCategory.find(@group_category_id).group_category_type_id
        )
      end

      # find parent group and update with association with group category type
      @parent = Group.find(params[:children].first[0])&.parent
      @parent.update(group_category_type_id: @parent.children.first.group_category_type_id) if @parent
  end

  def all_incoming_labels_are_none?
    params[:children].all? { |child| child[1][:group_category_id] == "" }
  end

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
