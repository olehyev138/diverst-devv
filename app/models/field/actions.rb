module Field::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [:field_definer]
    end

    def build(base = Field, diverst_request, params)
      raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?

      # create the new item
      item = base.new(params[symbol])

      # add enterprise id if exists & not set
      if item.has_attribute?(:enterprise_id) && item[:enterprise_id].blank?
        item.enterprise_id = diverst_request.user.enterprise_id
      end

      # save the item
      unless item.save
        raise InvalidInputException.new({message: item.errors.full_messages.first, attribute: item.errors.messages.first.first})
      end

      item
    end
  end
end
