module Api::V1::Concerns::Archivable
  extend ActiveSupport::Concern
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
