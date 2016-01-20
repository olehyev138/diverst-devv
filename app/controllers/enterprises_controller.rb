class EnterprisesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_enterprise, except: [:index, :new, :create]

  layout :resolve_layout

  def update
    if @enterprise.update_attributes(enterprise_params)
      redirect_to :back
    else
      render params["source"]
    end
  end

  def edit_branding
    @enterprise.theme = Theme.new if @enterprise.theme.nil?
  end

  def update_branding
    if !@enterprise.theme.nil? && @enterprise.theme.default?
      @enterprise.theme = Theme.create(enterprise_params[:theme_attributes])
      if @enterprise.save
        redirect_to action: :edit_branding
      else
        render :edit_branding
      end
    else
      if @enterprise.update_attributes(enterprise_params)
        redirect_to action: :edit_branding
      else
        render :edit_branding
      end
    end
  end

  def restore_default_branding
    @enterprise.theme.delete
    redirect_to :back
  end

  protected

  def resolve_layout
    case action_name
    when "edit_algo", "edit_mobile_fields"
      "handshake"
    else
      "global_settings"
    end
  end

  def set_enterprise
    @enterprise = Enterprise.find(params[:id] || params[:enterprise_id])
  end

  def enterprise_params
    params
    .require(:enterprise)
    .permit(
      :has_enabled_saml,
      :idp_entity_id,
      :idp_sso_target_url,
      :idp_slo_target_url,
      :idp_cert,
      :yammer_import,
      theme_attributes: [
        :primary_color,
        :logo
      ],
      mobile_fields_attributes: [
        :id,
        :field_id,
        :_destroy
      ],
      fields_attributes: [
        :id,
        :title,
        :_destroy,
        :gamification_value,
        :show_on_vcard,
        :saml_attribute,
        :type,
        :match_exclude,
        :match_weight,
        :match_polarity,
        :min,
        :max,
        :options_text,
        :alternative_layout
      ],
      yammer_field_mappings_attributes: [
        :id,
        :yammer_field_name,
        :diverst_field_id,
        :_destroy
      ]
    )
  end
end