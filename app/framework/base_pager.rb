module BasePager
    
    def self.included(klass)
        klass.extend ClassMethods 
    end
  
    module ClassMethods
    
        attr_accessor :user, :default_order, :default_order_by, :page, :count
        
        def set_defaults
            self.default_order = :desc
            self.default_order_by = "#{self.table_name}.id"
            self.page = 1
            self.count = 10
        end
    
        def pager(diverst_request, params = {}, search_method = :search)
            return elasticsearch(diverst_request, params) if params[:search]
            
            set_defaults

            raise Exception.new unless default_order_by.present?
            raise Exception.new unless default_order.present?
            
            #diverst_request.ability.authorize! :search, self.class, :message => "You are not authorized to search for #{self.name.pluralize}."
            
            # set the parameters
            item_page = params[:page].present? ? params[:page].to_i : page
            item_count = params[:count].present? ? params[:count].to_i : count
            offset = (item_page - 1) * item_count
            orderBy = params[:orderBy].present? ? params[:orderBy] : default_order_by
            order = params[:order].present? ? params[:order] : default_order
            
            # get the search method
            search_method_obj = self.method(search_method)

            # search
            total = search_method_obj.call(params, diverst_request).count
            items = search_method_obj.call(params, diverst_request)
                              .order("#{orderBy} #{order}")
                              .limit(item_count)
                              .offset(offset)
            
            # return the page
            return Page.new(items, total)
        end
    end
end
