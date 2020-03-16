module Group::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_scopes
      ['all_children', 'all_parents', 'no_children', 'is_private']
    end

    def base_preloads
      [ :news_feed, :annual_budgets, :children, :enterprise, :logo_attachment, :banner_attachment, enterprise: [ :theme ], children: base_preload_no_recursion ]
    end

    def base_preload_no_recursion
      [ :news_feed, :children, :enterprise, :logo_attachment, :banner_attachment, enterprise: [ :theme ] ]
    end

    def base_attributes_preloads
      [ :news_feed, :annual_budgets, :logo_attachment, :banner_attachment, enterprise: [ :theme ] ]
    end

    def update_child_categories(diverst_request, params)
      raise BadRequestException.new "#{self.name.titleize} ID required" if params[:id].nil?
      raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?

      category_types = params[:category_types] # {group_id: num, category_id: num}
      # get the item being updated
      item = find(params[:id])

      # check if the user can update the item


    end
  end
end
