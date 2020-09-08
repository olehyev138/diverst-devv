class Api::V1::NewsFeedLinksController < DiverstController
  prepend Api::V1::Concerns::Archivable

  def approve
    params[klass.symbol] = { approved: true }
    item = klass.find(params[:id])
    base_authorize(item)
    raise BadRequestException.new('Already Approved') if item.approved?

    render status: 200, json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def pin
    item = klass.find(params[:id])
    params[klass.symbol] = payload
    params[klass.symbol][:is_pinned] = true

    params[klass.symbol][:id] = item.id
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
    item = klass.find(params[:id])
    params[klass.symbol] = payload
    params[klass.symbol][:is_pinned] = false

    params[klass.symbol][:id] = item.id
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

  def payload
    params.require(klass.symbol).permit(
        'news_feed_id',
        'news_feed_id',
      )
  end

  private def model_map(model)
    model.link
  end
end
