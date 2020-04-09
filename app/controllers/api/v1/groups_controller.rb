class Api::V1::GroupsController < DiverstController
  include Api::V1::Concerns::DefinesFields
  include Api::V1::Concerns::Updatable

  def create_field
    params[:field][:field_type] = 'regular'
    super
  end

  def current_annual_budgets
    base_authorize(klass)
    params[:parent_id] = nil
    params[:preload] = 'budget'
    render status: 200, json: klass.budget_index(self.diverst_request, params.permit!), use_serializer: GroupWithBudgetSerializer
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def carryover_annual_budget
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.carryover_annual_budget(self.diverst_request), use_serializer: GroupWithBudgetSerializer
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def reset_annual_budget
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.reset_annual_budget(self.diverst_request), use_serializer: GroupWithBudgetSerializer
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def current_annual_budget
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.current_annual_budget!
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update_categories
    params[klass.symbol] = payload
    params[:children].each do | category |
      unless category[:group_category_id].nil?
        # get group_category_type_id
        category[:group_category_type_id] = GroupCategory.find(category[:group_category_id]).group_category_type_id
        if @tempCat.nil?
          @tempCat = category[:group_category_type_id]
        end
        # if all subgroups' group_category_type_id not consistent, raise exception
        if @tempCat != category[:group_category_type_id]
          raise InvalidInputException
        end
      end
    end
    params[:group_category_type_id] = @tempCat
    render status: 200, json: klass.update_child_categories(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  private

  def load_sums(result)
    result.items = result.items.load_sums
    result
  end

  def assign_leaders
    params[klass.symbol] = payload
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def leaders_payload
    params
        .require(klass.symbol)
        .permit(
            leaders_ids: [],
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
