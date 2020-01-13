module Updatable
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  module ClassMethods
    def set_fields_defaults
      @f_default_order = :asc
      @f_default_order_by = 'fields.id'
      @f_page = 0
      @f_count = 5
    end

    def set_updates_defaults
      @u_default_order = :asc
      @u_default_order_by = "#{self.table_name}.report_date"
      @u_page = 0
      @u_count = 5
    end

    def get_metrics_params(params, type)
      item_page = if params["#{type}_page"].present?
                    params["#{type}_page"].to_i
                  else
                    type == 'update' ? @u_page : @f_page
                  end
      item_count = if params["#{type}_count"].present?
                     params["#{type}_count"].to_i
                   else
                     type == 'update' ? @u_count : @f_count
                   end
      offset = item_page * item_count
      order_by = type == 'update' ? @u_default_order_by : @f_default_order_by
      order = type == 'update' ? @u_default_order : @f_default_order

      [item_page, item_count, offset, order_by, order]
    end

    def metrics_index(diverst_request, params, updatable:, base: self)
      updatable

      set_fields_defaults
      set_updates_defaults

      raise Exception.new if @f_default_order.blank?
      raise Exception.new if @f_default_order_by.blank?
      raise Exception.new if @u_default_order.blank?
      raise Exception.new if @u_default_order_by.blank?

      # set the parameters
      u_item_page, u_item_count, u_offset, u_order_by, u_order = get_metrics_params(params, 'update')
      f_item_page, f_item_count, f_offset, f_order_by, f_order = get_metrics_params(params, 'field')

      # search
      total = base.count
      items = base
                  .preload(base_preloads || [])
                  .order("#{u_order_by} #{u_order}")
                  .limit(u_item_count)
                  .offset(u_offset)

      fields_total = updatable.fields.count
      fields = updatable.fields
                   .preload(Field.base_preloads || [])
                   .order("#{f_order_by} #{f_order}")
                   .limit(f_item_count)
                   .offset(f_offset)

      fields.load
      field_ids = fields.ids
      items.load

      fields_hash = fields.reduce({ __updates__: [] }) { |sum, n| sum[n.title] = []; sum }

      items.each do |update|
        fields_hash[:__updates__].append(update.as_json)
        update.field_data.select { |fd| field_ids.include? fd.field_id }.each do |fd|
          abs_var, rel_var = update.variance_from_previous(fd.field)
          fields_hash[fd.field.title].append({
                                                 update_id: update.id,
                                                 prev_id: update.previous_id,
                                                 value: fd.deserialized_data,
                                                 variance_with_prev: ("#{(rel_var * 100).round(1)}%" rescue nil)
                                             })
        end
      end

      { items: fields_hash.as_json, updates_total: total, fields_total: fields_total }
    end
  end
end
