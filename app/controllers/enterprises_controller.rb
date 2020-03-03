class EnterprisesController < ApplicationController
  before_action :authenticate_user!, except: [:calendar]
  before_action :set_enterprise, except: [:index, :new, :create, :calendar]
  after_action :verify_authorized, except: :calendar
  after_action :allow_iframe, only: [:calendar]
  after_action :visit_page, only: [:edit, :edit_fields, :edit_budgeting, :edit_mobile_fields,
                                   :edit_auth, :edit_branding, :edit_algo, :calendar]

  layout :resolve_layout

  def edit
    authorize @enterprise, :enterprise_manage?
  end

  def update
    authorize @enterprise
    update_enterprise
  end

  def update_posts
    authorize @enterprise, :manage_posts?

    if @enterprise.update_attributes(enterprise_params)
      flash[:notice] = 'Your enterprise was updated'
      track_activity(@enterprise, :update)
      redirect_to :back
    else
      flash[:alert] = 'Your enterprise was not updated. Please fix the errors'
      redirect_to :back
    end
  end

  def edit_fields
    authorize @enterprise
  end

  def update_enterprise
    if @enterprise.update_attributes(enterprise_params)
      flash[:notice] = 'Your enterprise was updated'
      track_activity(@enterprise, :update)
      redirect_to :back
    else
      flash[:alert] = 'Your enterprise was not updated. Please fix the errors'
      redirect_to :back
    end
  end

  def update_mapping
    authorize @enterprise, :edit_fields?
    update_enterprise
  end

  def update_fields
    authorize @enterprise, :edit_fields?
    update_enterprise
  end

  def edit_budgeting
    authorize @enterprise, :update?
    @groups = @enterprise.groups
  end

  # not sure if this is supposed to be here
  def edit_cdo
    authorize @enterprise, :update?
  end

  # missing a template layout called handshake
  def edit_mobile_fields
    authorize @enterprise
  end

  def edit_auth
    authorize @enterprise
  end

  def auto_archive_switch
    authorize @enterprise, :auto_archive_settings_manage?
    @enterprise.archive_switch
    render nothing: true
  end

  def enable_onboarding_consent
    authorize @enterprise, :manage_onboarding_consent?
    @enterprise.consent_toggle
    render nothing: true
  end

  def update_auth
    authorize @enterprise, :edit_auth?
    update_enterprise
  end

  def edit_branding
    authorize @enterprise
    @emails = @enterprise.emails
    set_theme
  end

  # missing template
  def edit_algo
    authorize @enterprise, :update?
  end

  def update_branding
    authorize @enterprise
    @enterprise.theme.try(:destroy)
    set_theme

    if @enterprise.update_attributes(theme_attributes: enterprise_params[:theme])

      @enterprise.theme.compile

      flash[:notice] = 'Enterprise branding was updated'
      track_activity(@enterprise, :update_branding)
      redirect_to action: :edit_branding

    else
      flash[:alert] = 'Enterprise branding was not updated. Please fix the errors'
      render :edit_branding
    end
  end

  def update_branding_info
    authorize @enterprise, :manage_branding?
    update_enterprise
  end

  def delete_attachment
    authorize @enterprise, :update?

    if ['xml_sso_config', 'banner'].include?(params[:attachment])
      @enterprise.send("#{ params[:attachment] }=", nil)
    end

    if @enterprise.save
      flash[:notice] = 'Enterprise attachment was removed'
      redirect_to :back
    else
      flash[:alert] = 'Enterprise attachment was not removed. Please fix the errors'
      redirect_to :back
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
    when 'edit_algo'
      'mentorship'
    when 'edit_algo', 'edit_mobile_fields'
      'handshake'
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
        :enable_pending_comments,
        :enable_social_media,
        :enable_rewards,
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
        :onboarding_sponsor_media,
        :company_video_url,
        :banner,
        :home_message,
        :xml_sso_config,
        :time_zone,
        :mentorship_module_enabled,
        :disable_likes,
        :collaborate_module_enabled,
        :default_from_email_address,
        :default_from_email_display_name,
        :redirect_all_emails,
        :redirect_email_contact,
        :disable_emails,
        :plan_module_enabled,
        :name,
        :scope_module_enabled,
        :auto_archive,
        :expiry_age_for_resources,
        :unit_of_expiry_age,
        :onboarding_consent_enabled,
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
          :required,
          :add_to_member_list
        ],
        yammer_field_mappings_attributes: [
          :id,
          :yammer_field_name,
          :diverst_field_id,
          :_destroy
        ],
        sponsors_attributes: [
          :id,
          :sponsor_name,
          :sponsor_title,
          :sponsor_message,
          :sponsor_media,
          :disable_sponsor_message,
          :_destroy
        ]
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'edit'
      'Enterprise Settings'
    when 'edit_fields'
      'Fields Edit'
    when 'edit_budgeting'
      'Budget Settings'
    when 'edit_mobile_fields'
      'Mobile Fields Settings'
    when 'edit_auth'
      'Authentication Settings'
    when 'edit_branding'
      'Branding Settings'
    when 'edit_algo'
      'Algorithm Settings'
    when 'calendar'
      'Calender'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
