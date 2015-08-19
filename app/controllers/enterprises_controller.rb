class EnterprisesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_enterprise, except: [:index, :new, :create]

  def index
    @enterprises = Enterprise.all
  end

  def new
    @enterprise = Enterprise.new
  end

  def update
    if @enterprise.update_attributes(enterprise_params)
      redirect_to action: "edit"
    else
      render :edit
    end
  end

  protected

  def set_enterprise
    @enterprise = Enterprise.find(params[:id])
  end

  def enterprise_params
    params.require(:enterprise).permit(fields_attributes: [:id, :title, :_destroy, :gamification_value, :show_on_vcard, :type, options_attributes: [:id, :title, :_destroy]])
  end
end
