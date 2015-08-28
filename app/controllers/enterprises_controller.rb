class EnterprisesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_enterprise, only: [:edit, :update, :delete]

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
    params.require(:enterprise).permit(:has_enabled_saml, :idp_entity_id, :idp_sso_target_url, :idp_slo_target_url, :idp_cert, fields_attributes: [:id, :title, :_destroy, :gamification_value, :show_on_vcard, :saml_attribute, :type, :match_exclude, :match_weight, :match_polarity, :min, :max, :options_text])
  end
end