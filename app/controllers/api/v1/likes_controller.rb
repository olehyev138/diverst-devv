class Api::V1::LikesController < DiverstController
  before_action :is_liked

  def is_liked
    if payload[:news_feed_link_id].present?
      @isliked = Like.find_by(user: self.diverst_request.user, news_feed_link_id: payload[:news_feed_link_id])
    else
      @isliked = Like.find_by(user: self.diverst_request.user, answer_id: payload[:answer_id])
    end
  end

  def create
    params[klass.symbol] = payload

    if params[klass.symbol][:news_feed_link_id].present? && params[klass.symbol][:answer_id].present?
      raise InvalidInputException.new({ message: 'Can\'t like Answer and News Item', attribute: item.errors.messages.first.first})
    end

    if @isliked.present?
      raise InvalidInputException.new({ message: 'Answer and News Item is already liked', attribute: item.errors.messages.first.first})
    else
      begin
        base_authorize(klass)
        render status: 201, json: klass.build(self.diverst_request, params)
      rescue => e
        case e
        when InvalidInputException
          raise
        else
          raise BadRequestException.new(e.message)
        end
      end
    end
  end

  def unlike
    if @isliked.present?
      begin
        base_authorize @isliked
        @isliked.destroy
        render status: 200, json: { works: true }
      rescue => e
        raise BadRequestException.new(e.message)
      end
    else
      raise BadRequestException.new('Can\'t unlike Answer and News Item')
    end
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
