class EnterprisesController < ApplicationController
  before_action :set_enterprise, except: [:index, :new, :create, :calendar]
  after_action :verify_authorized, except: :calendar
  after_action :allow_iframe, only: [:calendar]

  layout :resolve_layout

  def edit
    authorize @enterprise, :update?
  end

  def update
    authorize @enterprise
    
    if @enterprise.update_attributes(enterprise_params)
      flash[:notice] = "Your enterprise was updated"
      redirect_to :back
    else
      flash[:alert] = "Your enterprise was not updated. Please fix the errors"
      render params['source']
    end
  end

  def edit_fields
    authorize @enterprise
  end

  def edit_budgeting
    authorize @enterprise, :update?
    @groups = @enterprise.groups
  end

  def bias
    authorize @enterprise, :update?
  end

  # not sure if this is supposed to be here
  def edit_cdo
    authorize @enterprise, :update?
  end
  
  # missing a template
  def edit_mobile_fields
    authorize @enterprise
  end

  def edit_auth
    authorize @enterprise
  end

  def edit_branding
    authorize @enterprise

    set_theme
  end
  
  # missing template
  def edit_algo
    authorize @enterprise, :edit?
  end

  def update_branding
    authorize @enterprise

    set_theme

    if @enterprise.update_attributes(theme_attributes: enterprise_params[:theme])
      flash[:notice] = "Enterprise branding was updated"
      redirect_to action: :edit_branding
    else
      flash[:alert] = "Enterprise branding was not updated. Please fix the errors"
      render :edit_branding
    end
  end

  def delete_attachment
    authorize @enterprise, :update?

    if ["xml_sso_config", "banner"].include?(params[:attachment])
      @enterprise.send("#{ params[:attachment] }=", nil)
    end

    if @enterprise.save
      flash[:notice] = "Enterprise attachment was removed"
      redirect_to :back
    else
      flash[:alert] = "Enterprise attachment was not removed. Please fix the errors"
      render :back
    end
  end

  def restore_default_branding
    authorize @enterprise
    @enterprise.theme.try(:destroy)
    redirect_to :back
  end

  def calendar
    @enterprise = Enterprise.find(params[:id])
    render layout: false
  end

  protected

  def resolve_layout
    case action_name
    when 'edit_algo', 'edit_mobile_fields'
      'handshake'
    when 'bias'
      'bias'
    else
      'global_settings'
    end
  end

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_theme
    @theme = if @enterprise.theme.nil?
      Theme.new
    else
      @enterprise.theme
    end
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
        :cdo_message_email,
        :privacy_statement,
        :cdo_name,
        :cdo_title,
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
