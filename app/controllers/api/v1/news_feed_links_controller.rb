class Api::V1::NewsFeedLinksController < DiverstController
  include Api::V1::Concerns::Archivable

  def pin
    params[klass.symbol][:is_pinned] = TRUE
    params[klass.symbol] = pin_payload
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

  def un_pin
    params[klass.symbol][:is_pinned] = FALSE
    params[klass.symbol] = pin_payload
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

  def pin_payload
    params.require(klass.symbol).permit(
        :id,
        :is_pinned
      )
  end
end
