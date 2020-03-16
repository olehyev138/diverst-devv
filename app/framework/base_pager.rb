module BasePager
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def set_defaults
      @default_order = :desc
      @default_order_by = "#{self.table_name}.id"
      @page = 0
      @count = 10
    end

    def get_params(params)
      item_page = params[:page].present? ? params[:page].to_i : @page
      item_count = params[:count].present? ? params[:count].to_i : @count
      offset = item_page * item_count
      order_by = params[:orderBy].presence || @default_order_by
      order = params[:order].presence || @default_order
      sum_column = params[:sum]

      [item_page, item_count, offset, order_by, order, sum_column]
    end

    def order_string(order_by, order)
      "#{order_by} #{order}"
    end

    def pager(diverst_request, params = {}, search_method = :lookup, base: self, policy: nil)
      return elasticsearch(diverst_request, params) if params[:elasticsearch]

      set_defaults

      raise Exception.new if @default_order_by.blank?
      raise Exception.new if @default_order.blank?

      # set the parameters
      item_page, item_count, offset, order_by, order, sum_column = get_params(params)

      # get the search method
      search_method_obj = self.method(search_method)

      # search
      partial_query = search_method_obj.call(params, diverst_request, base: base, policy: policy)
      if sum_column
        sum, total = partial_query.sum_and_count(sum_column) if sum_column
      else
        total = partial_query.count
      end
      items = partial_query
                  .order(order_string(order_by, order))

      if item_count >= 0
        items = items.limit(item_count).offset!(offset)
      end

      # return the page
      Page.new(items, total, sum)
    end

    def pager_with_query(query, params = {})
      set_defaults

      raise Exception.new if @default_order_by.blank?
      raise Exception.new if @default_order.blank?

      # set the parameters
      item_page, item_count, offset, order_by, order = get_params(params)

      # search
      total = query.count
      items = query
                .order("#{order_by} #{order}")
                .limit(item_count)
                .offset(offset)

      # return the page
      Page.new(items, total)
    end
  end
end
