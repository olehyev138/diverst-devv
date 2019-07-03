module BasePager
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    attr_accessor :user, :default_order, :default_order_by, :page, :count

    def set_defaults
      self.default_order = :desc
      self.default_order_by = "#{self.table_name}.id"
      self.page = 0
      self.count = 10
    end

    def pager(diverst_request, params = {}, search_method = :lookup)
      return elasticsearch(diverst_request, params) if params[:search]

      set_defaults

      raise Exception.new if default_order_by.blank?
      raise Exception.new if default_order.blank?

      # set the parameters
      item_page = params[:page].present? ? params[:page].to_i : page
      item_count = params[:count].present? ? params[:count].to_i : count
      offset = item_page * item_count
      orderBy = params[:orderBy].presence || default_order_by
      order = params[:order].presence || default_order

      # get the search method
      search_method_obj = self.method(:lookup)

      # search
      total = search_method_obj.call(params, diverst_request).count
      items = search_method_obj.call(params, diverst_request)
                        .order("#{orderBy} #{order}")
                        .limit(item_count)
                        .offset(offset)

      # return the page
      Page.new(items, total)
    end
  end
end
