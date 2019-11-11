class GroupCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update, :destroy]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :edit, :view_all]

  layout :resolve_layout

  def index
    authorize Group, :manage_all_groups?

    @parent = Group.find(params[:parent_id].to_i)
    @categories = current_user.enterprise.group_categories
  end

  def new
    authorize Group, :manage_all_groups?
    @parent = Group.find(params[:parent_id].to_i) unless params[:parent_id].to_i.zero?
    @group_category_type = current_user.enterprise.group_category_types.new
  end

  def create
    authorize Group, :manage_all_groups?

    @group_category_type = current_user.enterprise.group_category_types.new(category_type_params)
    @parent = Group.find(params[:group_category_type][:parent_id].to_i) unless params[:group_category_type][:parent_id].to_i.zero?

    if @group_category_type.save
      flash[:notice] = "You just created a category named #{@group_category_type.name}"

      if @parent
        redirect_to group_categories_url(parent_id: @parent.id)
      else
        redirect_to view_all_group_categories_url
      end
    else
      flash.now[:alert] = 'Something went wrong. Please check errors.'
      render :new
    end
  end

  def edit
    authorize Group, :manage_all_groups?
  end

  def update
    authorize Group, :manage_all_groups?

    if @category.update(category_params)
      flash[:notice] = 'Update category name'
      redirect_to view_all_group_categories_url
    else
      flash.now[:alert] = 'Something went wrong. please fix errors'
      render 'edit'
    end
  end

  def destroy
    authorize Group, :manage_all_groups?

    @category.destroy
    flash[:notice] = 'Category successfully removed.'
    redirect_to :back
  end

  def update_all_sub_groups
    authorize Group, :manage_all_groups?

    if all_incoming_labels_are_none?
      categorize_sub_groups
      flash[:notice] = 'No labels were submitted'
      redirect_to :back
    else
      if all_labels_are_of_the_same_category_type? || at_least_one_label_is_blank_and_other_labels_of_same_category_type?
        categorize_sub_groups
        flash[:notice] = 'Categorization successful'
        redirect_to :back
      else
        flash[:alert] = 'Categorization failed because you submitted labels of different category type'
        redirect_to :back
      end
    end
  end

  def view_all
    authorize Group, :manage_all_groups?
    @categories = current_user.enterprise.group_categories
    @category_types = current_user.enterprise.group_category_types
  end


  private

  def at_least_one_label_is_blank?
    params[:children].any? { |child| child[1][:group_category_id] == '' }
  end

  def other_labels_not_blank_and_same_category_type?
    array_of_non_blank_labels = []
    params[:children].each do |child|
      next if child[1][:group_category_id] == ''

      array_of_non_blank_labels << child[1][:group_category_id]
    end

    array_of_non_blank_labels.all? { |group_category_id| GroupCategory.find(group_category_id)
      .group_category_type_id == GroupCategory.find(array_of_non_blank_labels[0]).group_category_type_id
    }
  end

  def at_least_one_label_is_blank_and_other_labels_of_same_category_type?
    at_least_one_label_is_blank? && other_labels_not_blank_and_same_category_type?
  end

  def all_labels_are_of_the_same_category_type?
    params[:children].each do |child|
      if child[1][:group_category_id] != ''
        @group_category_id = child[1][:group_category_id].to_i
        break
      end
    end

    params[:children].all? do |child|
      GroupCategory.find(child[1][:group_category_id])
      .group_category_type_id == GroupCategory.find(@group_category_id).group_category_type_id if child[1][:group_category_id].present?
    end
  end

  def categorize_sub_groups
    # check params to avoid update of Group object with 0 value
    params[:children].each do |child|
      if child[1][:group_category_id] != ''
        @group_category_id = child[1][:group_category_id].to_i
        break
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
    @parent.update(group_category_type_id: GroupCategory.find_by(id: @group_category_id)&.group_category_type_id) if @parent
  end

  def all_incoming_labels_are_none?
    params[:children].all? { |child| child[1][:group_category_id] == '' }
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Group Categories'
    when 'new'
      'Group Category Creation'
    when 'edit'
      "Group Category Edit: #{@category.to_label}"
    when 'view_all'
      'View All Group Categories'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
