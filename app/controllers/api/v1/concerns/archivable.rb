module Api::V1::Concerns::Archivable
  extend ActiveSupport::Concern
  def archive
    item = klass.find(params[:id])
    params[klass.symbol] = archive_payload
    params[klass.symbol][:archived_at] = Time.now
    params[klass.symbol][:id] = item.id

    base_authorize(item)
    track_activity(item)
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
    item = klass.find(params[:id])
    params[klass.symbol][:archived_at] = nil
    params[klass.symbol] = archive_payload
    params[klass.symbol][:id] = item.id

    base_authorize(item)
    track_activity(item)
    render status: 200, json: klass.update(self.diverst_request, params)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  private def action_map(action)
    case action
    when :archive then 'archive'
    when :un_archive then 'restore'
    else super
    end
  end
end
