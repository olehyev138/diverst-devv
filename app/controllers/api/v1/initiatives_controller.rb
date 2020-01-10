class Api::V1::InitiativesController < DiverstController
  include Api::V1::Concerns::DefinesFields

  def generate_qr_code
    render status: 200, json: klass.generate_qr_code(diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def payload
    params
      .require(:initiative)
      .permit(
        :name,
        :description,
        :start,
        :end,
        :max_attendees,
        :pillar_id,
        :location,
        :picture,
        :owner_group_id,
        :budget_item_id,
        :estimated_funding,
        :archived_at,
        :from, # For filtering
        :to, # For filtering
        :annual_budget_id,
        participating_group_ids: [],
        segment_ids: [],
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
        checklist_items_attributes: [
          :id,
          :title,
          :is_done,
          :_destroy
        ],
      )
  end
end
