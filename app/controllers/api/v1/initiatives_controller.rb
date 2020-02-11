class Api::V1::InitiativesController < DiverstController
  include Api::V1::Concerns::DefinesFields
  include Api::V1::Concerns::Updatable

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

  def archive
    params[klass.symbol][:archived_at] = Time.now
    params[klass.symbol] = archive_payload
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

  def archive_payload
    params.require(klass.symbol).permit(
        :id,
        :archived_at
    )
  end

  def un_archive
    params[klass.symbol][:archived_at] = nil
    params[klass.symbol] = archive_payload
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
end
