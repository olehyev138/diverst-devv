class Api::V1::GroupsController < Api::V1::ApiController
  def index
    authorize Group
    render json: self.current_user.enterprise.groups
  end

  def show
    render json: find_and_authorize(params, :show?)
  end

  def create
    # create the group
    group = self.current_user.enterprise.groups.new(group_params)

    # save the group
    if group.save
      return render status: 201, json: group
    else
      return render status: 422, json: { message: group.errors.full_messages.first }
    end
  end

  def update
    # update the group
    group = find_and_authorize(params, :update?)

    if group.update_attributes(group_params)
      return render json: group
    else
      return render status: 422, json: { message: group.errors.full_messages.first }
    end
  end

  def destroy
    find_and_authorize(params, :destroy?).destroy
    head :no_content
  end

  private

  def find_and_authorize(params, action)
    # find the group
    group = self.current_user.enterprise.groups.find(params[:id])
    # authorize
    authorize group, action
    # return the group
    group
  end

  def group_params
    params
        .require(:group)
        .permit(
          :name,
          :description,
          :logo,
          :banner,
          :yammer_create_group,
          :yammer_sync_users,
          :pending_users,
          :members_visibility,
          :messages_visibility,
          :calendar_color,
          :active,
          :sponsor_name,
          :sponsor_title,
          :sponsor_image,
          :sponsor_message,
          manager_ids: [],
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
          ]
        )
  end
end
