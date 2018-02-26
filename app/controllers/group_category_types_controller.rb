class GroupCategoryTypesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_category_type, only: [:edit, :update, :add_category, :update_with_new_category, :destroy]

  layout :resolve_layout


  def edit
    authorize Group
  end


  def update
    authorize Group
    if @category_type.update(category_type_params)
      flash[:notice] = "Update category type name"
      redirect_to view_all_group_categories_url
    else 
      flash[:alert] = "Something went wrong. please fix errors"
      render 'edit'
    end
  end

  def destroy
    authorize Group

    @category_type.destroy
    flash[:notice] = "Successfully deleted categories"
    redirect_to :back
  end

  def add_category
    authorize Group
  end

  def update_with_new_category
    authorize Group

    if @category_type.update(category_type_params)
      flash[:notice] = "You successfully added categories to #{@category_type.name}"
      redirect_to view_all_group_categories_url
    else
      flash[:alert] = "Something went wrong. Please check errors."
      render :add_category
    end
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

  def set_category_type
  	@category_type = current_user.enterprise.group_category_types.find(params[:id])
  end
end
