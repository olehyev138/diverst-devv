class Api::V1::PollsController < DiverstController
  include Api::V1::Concerns::DefinesFields

  def create_and_publish
    params[klass.symbol] = payload
    base_authorize(klass)

    new_item = klass.build(self.diverst_request, params)
    track_activity(new_item)
    new_item = new_item.publish!
    render status: 201, json: new_item
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def update_and_publish
    params[klass.symbol] = payload
    item = klass.find(params[:id])
    base_authorize(item)

    updated_item = klass.update(self.diverst_request, params)
    track_activity(updated_item)
    updated_item = updated_item.publish!
    render status: 200, json: updated_item
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def publish
    item = klass.find(params[:id])
    base_authorize(item)
    published_item = item.publish!
    render status: 200, json: published_item
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def payload
    params.require(klass.symbol).permit(
      :title,
      :description,
      :initiative_id,
      :owner_id,
      group_ids: [],
      segment_ids: [],
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
        :alternative_layout
      ]
    )
  end
end
