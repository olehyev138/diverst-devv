class Api::V1::LikesController < DiverstController
  def create
    params[klass.symbol] = payload
    params[klass.symbol][:user_id] = current_user.id
    params[klass.symbol][:enterprise_id] = current_user.enterprise.id

    if params[klass.symbol][:news_feed_link_id].present? && params[klass.symbol][:answer_id].present?
      raise InvalidInputException.new({ message: 'Can\'t like Answer and News Item', attribute: item.errors.messages.first.first})
    end

    base_authorize(klass)

    render status:201, jason: klass.build(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def unlike
    render status: 200, json: { works: true }
  end

  def payload
    params
        .require(:initiative)
        .permit(
            :news_feed_link_id,
            :answer_id,
          )

  end
end
