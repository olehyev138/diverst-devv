module Api::V1::Concerns::Archivable
  extend ActiveSupport::Concern
  def archive
    params[klass.symbol][:archived_at] = Time.now
    params[klass.symbol] = archive_payload
    item = klass.find(params[:id])
    base_authorize(item)

    klass.update(self.diverst_request, params)
    track_activities(item)
    render status: 200, json: item
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

    klass.update(self.diverst_request, params)
    track_activities(item)
    render status: 200, json: item
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
