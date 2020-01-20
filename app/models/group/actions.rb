module Group::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_scopes
      ['all_children', 'all_parents', 'no_children', 'is_private']
    end

    def base_preloads
      [ :news_feed, :children, :enterprise, enterprise: [ :theme ], children: base_preload_no_recursion ]
    end

    def base_preloads_budget
      [ :annual_budgets, :children, children: [:annual_budgets, :children] ]
    end

    def base_preload_no_recursion
      [ :news_feed, :children, :enterprise, enterprise: [ :theme ] ]
    end

    def base_attributes_preloads
      [ :news_feed, enterprise: [ :theme ] ]
    end
  end
end
