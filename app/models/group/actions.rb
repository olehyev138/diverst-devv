module Group::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def carryover_annual_budget(diverst_request)
    raise BadRequestException.new "#{self.class.name.titleize} ID required" if id.blank?

    cab = self.current_annual_budget
    raise BadRequestException.new "#{self.class.name.titleize} has no annual budget" if cab.nil?

    unless cab.carryover!
      raise InvalidInputException.new({ message: cab.errors.full_messages.first, attribute: cab.errors.messages.first&.first })
    end

    self
  end

  def reset_annual_budget(diverst_request)
    raise BadRequestException.new "#{self.class.name.titleize} ID required" if id.blank?

    cab = self.current_annual_budget
    raise BadRequestException.new "#{self.class.name.titleize} has no annual budget" if cab.nil?

    unless cab.reset!
      raise InvalidInputException.new({ message: cab.errors.full_messages.first, attribute: cab.errors.messages.first.first })
    end

    self
  end

  module ClassMethods
    def base_query
      "LOWER(#{self.table_name}.name) LIKE :search OR LOWER(children_groups.name) LIKE :search"
    end

    # def base_left_joins(diverst_request) ##
    #   :children
    # end

    def valid_scopes
      ['all_children', 'possible_children', 'all_parents', 'no_children', 'is_private', 'replace_with_children', 'except_id', 'joined_groups']
    end

    # List of all attributes to preload.
    # Used when serializing a group itself
    def base_preloads(diverst_request) ##
      preloads = base_preload_no_recursion(diverst_request)
      associations = {}
      associations[:children] = base_attributes_preloads(diverst_request) if diverst_request.options[:with_children]
      associations[:parent] = base_attributes_preloads(diverst_request) if diverst_request.options[:with_parent]
      preloads.append(associations)
      preloads
    end

    # List of all attributes to preload when dealing with annual budgets.
    # Used when getting the list of budgets for all groups
    def base_preloads_budget ##
      [ :annual_budgets ]
    end

    # List of non-recursive attributes to preload.
    # Used as the preload fields for a groups children/parent as to prevent infinite recursion of base_preloads
    def base_preload_no_recursion(diverst_request)
      preloads = base_attributes_preloads(diverst_request)
      preloads.append(:children) if diverst_request.options[:with_children]
      preloads.append(:parent) if diverst_request.options[:with_parent]
      preloads
    end

    # List of basic attributes to preload.
    # Used when preloading groups field for other serializers (Like UserGroupSerializer)
    def base_attributes_preloads(diverst_request)
      preloads = [ :logo_attachment, :user_groups, :group_leaders ]
      preloads.append(:news_feed, :banner_attachment) if diverst_request.action == 'show'
      preloads.append(:annual_budgets) if diverst_request.options[:budget]
      preloads
    end

    def update_child_categories(diverst_request, params)
      raise BadRequestException.new "#{self.name.titleize} ID required" if params[:id].nil?
      raise BadRequestException.new "#{self.name.titleize} required" if params[symbol].nil?

      subgroups = params[:children] # {id: num, group_category_id: num}
      # update parent group category type id
      item = find(params[:id])
      item[:group_category_type_id] = params[:group_category_type_id]
      item.save!
      # update subgroup category id and category type id
      subgroups.each do |subgroup|
        item = Group.find(subgroup[:id])
        item[:group_category_id] = subgroup[:group_category_id]
        item[:group_category_type_id] = subgroup[:group_category_type_id]
        item.save!
      end
    end
  end
end
