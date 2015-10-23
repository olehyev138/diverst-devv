class EnterprisesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_enterprise, only: [:edit, :edit_auth, :edit_fields, :edit_mobile_fields, :edit_algo, :update, :delete]

  layout :resolve_layout

  def update
    # Render the appropriate view in case validation fails
    referer = env['HTTP_REFERER']
    routes = env['action_dispatch.routes']
    info = routes.recognize_path(referer, method: :get)

    if @enterprise.update_attributes(enterprise_params)
      redirect_to :back
    else
      render info[:action]
    end
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
    @enterprise = Enterprise.find(params[:id])
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
      ]
    )
  end
end