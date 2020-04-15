class Api::V1::NewsFeedLinksController < DiverstController
  prepend Api::V1::Concerns::Archivable

  def pin
    params[klass.symbol][:is_pinned] = true
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
    params[klass.symbol][:is_pinned] = false
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

  def model_map(model)
    model.link
  end
end
