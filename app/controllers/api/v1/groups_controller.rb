class Api::V1::GroupsController < DiverstController
  include Api::V1::Concerns::DefinesFields

  def index
    authorize klass, :index?

    params.permit![:parent_id] = nil
    super
  end

  def updates
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Update.index(self.diverst_request, params.except(:id).permit!, base: item.updates)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update_prototype
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Update.create_prototype(item)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create_update
    params[:update] = update_payload
    base_authorize(klass)
    item = klass.find(params[:id])

    render status: 201, json: Update.build(self.diverst_request, params, base: item.updates)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def metrics_index
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.updates.index(self.diverst_request, params.except(:id).permit!, updatable: item)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update_payload
    params
        .require(:update)
        .permit(
            :report_date,
            :comments,
            field_data_attributes: [
                :id,
                :data,
                :field_id,
            ],
          )
  end

  def payload
    params
    .require(klass.symbol)
    .permit(
      :name,
      :short_description,
      :description,
      :home_message,
      :logo,
      :private,
      :banner,
      :yammer_create_group,
      :yammer_sync_users,
      :yammer_group_link,
      :pending_users,
      :members_visibility,
      :messages_visibility,
      :event_attendance_visibility,
      :latest_news_visibility,
      :upcoming_events_visibility,
      :calendar_color,
      :active,
      :contact_email,
      :sponsor_image,
      :company_video_url,
      :layout,
      :parent_id,
      :group_category_id,
      :group_category_type_id,
      :position,
      :auto_archive,
      :expiry_age_for_news,
      :expiry_age_for_resources,
      :expiry_age_for_events,
      :unit_of_expiry_age,
      manager_ids: [],
      child_ids: [],
      member_ids: [],
      invitation_segment_ids: [],
      outcomes_attributes: [
        :id,
        :name,
        :_destroy,
        pillars_attributes: [
          :id,
          :name,
          :value_proposition,
          :_destroy
        ]
      ],
      fields_attributes: [
        :id,
        :title,
        :_destroy,
        :gamification_value,
        :show_on_vcard,
        :saml_attribute,
        :type,
        :min,
        :max,
        :options_text,
        :alternative_layout
      ],
      survey_fields_attributes: [
        :id,
        :title,
        :_destroy,
        :show_on_vcard,
        :saml_attribute,
        :type,
        :min,
        :max,
        :options_text,
        :alternative_layout
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
end
