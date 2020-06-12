module PollResponse::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:poll, :user, :field_data, field_data: FieldData.base_preloads]
    end

    def build(diverst_request, params)
      raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?

      # create the new item
      item = self.new(params[symbol])
      poll = Poll.find(item.poll_id)

      item.info.merge(fields: poll.fields, form_data: params['custom-fields'])
      item.user = diverst_request.user

      # save the item
      if not item.save
        raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first })
      end

      item
    end
  end
end
