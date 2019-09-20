class EnterpriseSerializer < ApplicationRecordSerializer
  attributes :id, :name, :sp_entity_id, :idp_entity_id, :idp_sso_target_url, :idp_slo_target_url,
             :idp_cert, :saml_first_name_mapping, :saml_last_name_mapping, :has_enabled_saml, :theme_id,
             :xml_sso_config_file_name, :xml_sso_config_content_type, :xml_sso_config_file_size,
             :time_zone, :theme

  def theme
    return nil if object.theme.nil?

    ThemeSerializer.new(object.theme).attributes
  end
end
