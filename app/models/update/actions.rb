module Update::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def base_preloads
      [ :field_data, :previous, field_data: FieldData.base_preloads ]
    end

    def set_progress_defaults
      @default_order = :desc
      @default_order_by = "#{self.table_name}.report_date"
      @page = 0
      @count = 5
    end

    def metrics_index(diverst_request, params, updatable:)
      set_progress_defaults

      raise Exception.new if @default_order_by.blank?
      raise Exception.new if @default_order.blank?

      # set the parameters
      item_page, item_count, offset, order_by, order = get_params(params)

      # search
      total = self.count
      items = self
                  .order("#{self.table_name}.report_date desc")
                  .limit(item_count)
                  .offset(offset)


      fields = updatable.fields
      fields_hash = fields.reduce({ updates: [] }) { |sum, n| sum[n.title] = []; sum }
      items.reverse_each do |update|
        fields_hash[:updates].append(update.as_json)
        update.field_data.each do |fd|
          abs_var, rel_var = update.variance_from_previous(fd.field)
          fields_hash[fd.field.title].append({
                                                 value: fd.deserialized_data,
                                                 variance_with_prev: ("#{rel_var.round(3) * 100}%" rescue nil)
                                             })
        end
      end

      { items: fields_hash.as_json, total: total }
    end
  end
end
