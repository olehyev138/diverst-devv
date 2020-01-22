module BaseBuilder
  def self.included(klass)
    klass.extend ClassMethods
  end

  # destroy item in the background

  def remove
    self.destroy
  end

  module ClassMethods
    # @param base [ActiveRecord], partial query
    def index(diverst_request, params, search_method = :lookup, base: self)
      pager(diverst_request, params, search_method, base: base)
    end

    # @param base [ActiveRecord::Association], association to create a new object from
    def build(diverst_request, params, base: self)
      raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?

      # create the new item
      item = base.new(params[symbol])

      # add enterprise id if exists & not set
      if item.has_attribute?(:enterprise_id) && item[:enterprise_id].blank?
        item.enterprise_id = diverst_request.user.enterprise_id
      end

      # save the item
      unless item.save
        raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first })
      end

      item
    end

    def show(diverst_request, params)
      raise BadRequestException.new "#{self.name.titleize} ID required" if params[:id].nil?

      # get the item
      item = self
      item = item.preload(base_preloads) if respond_to? 'base_preloads'
      item = item.find(params[:id])

      # check if the user can read it

      item
    end

    def update(diverst_request, params)
      raise BadRequestException.new "#{self.name.titleize} ID required" if params[:id].nil?
      raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?

      # get the item being updated
      item = find(params[:id])

      # check if the user can update the item

      # update
      if item.update_attributes(params[symbol].permit!)
        item
      else
        raise InvalidInputException.new({ message: item.errors.full_messages.first, attribute: item.errors.messages.first.first })
      end
    end

    def destroy(diverst_request, id)
      # check for required fields
      raise BadRequestException.new "#{self.name.titleize} ID required" if id.blank?

      item = find_by_id(id)
      return if item.nil?

      item.remove
    end

    def symbol
      self.table_name.singularize.to_sym
    end
  end
end
