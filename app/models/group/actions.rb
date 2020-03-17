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

      subgroups = params[:children] # {id: num, group_category_id: num}
      puts '******************************update parent group category type id*****************************************'
      # update parent group category type id
      item = find(params[:id])
      item[:group_category_type_id] = params[:group_category_type_id]
      item.save!
      puts '******************************update parent subgroup category type id*****************************************'
      # update subgroup category id and category type id
      subgroups.each do |subgroup|
        item = Group.find(subgroup[:id])
        item[:group_category_id] = subgroup[:group_category_id]
        item[:group_category_type_id] = subgroup[:group_category_type_id]
        item.save!
        puts 'actions-update-done'
      end
    end
  end
end
