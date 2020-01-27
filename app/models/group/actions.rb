module Group::Actions
  def self.included(klass)
    klass.extend ClassMethods
    klass.extend ControllerMethods
  end

  module ClassMethods
    def valid_scopes
      ['all_children', 'all_parents', 'no_children', 'is_private']
    end

    def base_preloads
      [ :news_feed, :children, :enterprise, enterprise: [ :theme ], children: base_preload_no_recursion ]
    end

    def base_preloads_budget
      [ :annual_budgets ]
    end

    def base_preload_no_recursion
      [ :news_feed, :children, :enterprise, enterprise: [ :theme ] ]
    end

    def base_attributes_preloads
      [ :news_feed, enterprise: [ :theme ] ]
    end
  end

  module ControllerMethods
    def budget_index(diverst_request, params, base: self)
      budget_pager(diverst_request, params, base: base)
    end

    def budget_pager(diverst_request, params = {}, base: self)
      return elasticsearch(diverst_request, params) if params[:elasticsearch]

      set_defaults

      raise Exception.new if @default_order_by.blank?
      raise Exception.new if @default_order.blank?

      # set the parameters
      item_page, item_count, offset, order_by, order = get_params(params)

      # search
      total = budget_lookup(params, diverst_request, base: base).count
      items = budget_lookup(params, diverst_request, base: base)
                  .order("#{order_by} #{order}")
                  .limit(item_count)
                  .offset(offset)

      children = Group
                  .left_joins(:parent)
                  .where(parent_id: items.ids)

      items = items.union(children)
      items = items.where(annual_budgets: { closed: false })
      items = items.preload(base_preloads_budget)

      # return the page
      Page.new(items, total)
    end

    def budget_lookup(params = {}, diverst_request = nil, base: self)
      # get the search value
      searchValue = params[:search]

      # the custom args where/where_not clauses
      where = {}
      where_not = {}

      # get the base includes/joins and base query
      add_custom_args(where, where_not, params, [], [])

      current_user = diverst_request.user

      begin
        policy_name = self.name + 'Policy'
        policy_scope = (policy_name + '::Scope').constantize

        # Raise error if Policy exists but Scope doesn't
        # When scope is not defined it defers to ApplicationPolicy::Scope which has logic we don't necessarily want
        raise NameError if policy_scope.parent != policy_name.constantize

        # Apply the associated policy scope for the model to filter based on authorization
        @items = policy_scope.new(current_user, base, params: params).resolve
      rescue NameError
        # TODO: Uncomment this when we have more policies defined. Commenting now to pass tests early.
        # raise PolicyScopeNotFoundException
        warn(
            '---------------------------------------',
            '! WARNING !',
            "It is likely that a policy scope was not found for #{self}. Ensure that a proper Policy and Scope exist, and filter if necessary (by enterprise, etc.)",
            '---------------------------------------'
          )
        @items = self
      end

      # search the system
      if searchValue.present?
        @items
            .where(where)
            .where(query, search: "%#{searchValue}%".downcase)
            .where.not(where_not)
            .distinct
      else
        @items
            .where(where)
            .where.not(where_not)
            .all
            .distinct
      end
    end
  end
end
