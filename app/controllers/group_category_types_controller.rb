class GroupCategoryTypesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_category_type, only: [:edit, :update]

  layout :resolve_layout


  def edit
    authorize Group
  end


  def update
    authorize Group
    if @category_type.update(category_type_params)
      flash[:notice] = "update category type name"
      redirect_to view_all_group_categories_url
    else 
      flash[:alert] = "something went wrong. please fix errors"
      render 'edit'
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
