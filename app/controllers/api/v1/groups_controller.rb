class Api::V1::GroupsController < DiverstController
  include Api::V1::Concerns::DefinesFields
  include Api::V1::Concerns::Updatable

  def create_field
    params[:field][:field_type] = 'regular'
    super
  end

  def index
    diverst_request.options[:with_children] = to_bool(params[:with_children])
    diverst_request.options[:with_parent] = to_bool(params[:with_parent])
    super
  end

  def show
    diverst_request.options[:with_children] = to_bool(params[:with_children])
    diverst_request.options[:with_parent] = to_bool(params[:with_parent])
    super
  end

  def current_annual_budget
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: item.current_annual_budget
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def current_child_budget
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200,
           json: Page.of(item.current_child_budgets)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def aggregate_budgets
    item = klass.find(params[:id])
    base_authorize(item)

    response = AnnualBudget.index(
      self.diverst_request,
      params, :return_base,
      policy: @policy,
      base: item.aggregate_budget_data
    )

    render status: 200, json: response, **diverst_request.options
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def current_annual_budgets
    base_authorize(klass)
    params[:parent_id] = nil
    diverst_request.options[:budgets] = true
    diverst_request.options[:with_children] = true
    render status: 200,
           json: klass.index(
             self.diverst_request,
             params.permit!,
           ),
           budgets: true,
           with_children: true,
           use_serializer: AdminGroupBudgetSerializer
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def carryover_annual_budget
    item = klass.find(params[:id])
    base_authorize(item)
    diverst_request.options[:budgets] = true
    updated_item = item.carryover_annual_budget(self.diverst_request)
    track_activity(updated_item)
    render status: 200, json: updated_item, budgets: true
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def reset_annual_budget
    item = klass.find(params[:id])
    base_authorize(item)
    diverst_request.options[:budgets] = true
    updated_item = item.reset_annual_budget(self.diverst_request)
    track_activity(updated_item)
    render status: 200, json: updated_item, budgets: true
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

  def calendar_colors
    base_authorize(klass)

    render status: 200, json: {
        items: GroupPolicy::Scope.new(current_user, Group).resolve
                   .select(:id, :name, :calendar_color, :enterprise_id)
                   .preload(:enterprise, enterprise: [:theme])
                   .distinct
                   .map do |g|
                 {
                     id: g.id,
                     name: g.name,
                     calendar_color: g.get_calendar_color,
                 }
               end
    }
  rescue => e
    case e
    when Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  private

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

  private

  def action_map(action)
    case action
    when :carryover_annual_budget then 'annual_budget_update'
    when :reset_annual_budget then 'annual_budget_update'
    else super
    end
  end
end
