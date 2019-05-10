class Api::V1::EnterprisesController < Api::V1::ApiController
  def update
    # update the enterprise
    enterprise = find_and_authorize(params, :update?)

    if enterprise.update_attributes(enterprise_params)
      return render json: enterprise
    else
      return render status: 422, json: { message: enterprise.errors.full_messages.first }
    end
  end

  def events
    # update the enterprise
    enterprise = find_and_authorize(params, :show?)
    render json: enterprise.initiatives
  end

  private

  def find_and_authorize(params, action)
    # get the enterprise
    enterprise = Enterprise.find(params[:id])
    # authorize
    raise BadRequestException.new 'Unauthorized' if self.current_user.enterprise.id != enterprise.id

    # return the enterprise
    enterprise
  end

  def enterprise_params
    params
        .require(:enterprise)
        .permit(
          :has_enabled_saml,
          :has_enabled_onboarding_email,
          :idp_entity_id,
          :idp_sso_target_url,
          :idp_slo_target_url,
          :idp_cert,
          :saml_first_name_mapping,
          :saml_last_name_mapping,
          :yammer_import,
          :cdo_message,
          :privacy_statement,
          :cdo_picture,
          :banner,
          :home_message,
          :xml_sso_config,
          :time_zone,
          theme: [
              :id,
              :primary_color,
              :use_secondary_color,
              :secondary_color,
              :logo,
              :logo_redirect_url
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
              :alternative_layout,
              :private,
              :required
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
