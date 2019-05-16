module BaseBuilder
    
    def self.included(klass)
        klass.extend ClassMethods 
    end
    
    # destroy item in the background
    
    def remove
        self.destroy
    end
  
    module ClassMethods
        
        def index(diverst_request, params, search_method = :search)
            pager(diverst_request, params, search_method)
        end
        
        def build(diverst_request, params)
            raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?
            
            # create the new item
            item = self.new(params[symbol].permit!)
            
            # save the item
            if not item.save
                raise UnprocessableException.new(item)
            end
            
            return item
        end
        
        def show(diverst_request, params)
            raise BadRequestException.new "#{self.name.titleize} ID required" if params[:id].nil?
            
            # get the item
            item = find(params[:id])
            
            # check if the user can read it
            
            return item
        end
        
        def update(diverst_request, params)
            raise BadRequestException.new "#{self.name.titleize} ID required" if params[:id].nil?
            raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?
            
            # get the item being updated
            item = find(params[:id])
            
            # check if the user can update the item
        
            # update
            if item.update_attributes(params[symbol].permit!)
                return item
            else
                raise UnprocessableException.new(item)
            end
        end
    
        def destroy(diverst_request, id)
            # check for required fields
            raise BadRequestException.new "#{self.name.titleize} ID required" unless id.present?
            
            item = find_by_id(id)
            return if item.nil?

            item.remove
        end
        
        private
        
        def symbol
            self.table_name.singularize.to_sym
        end
    end
end