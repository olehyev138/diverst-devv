class ConvertKeysToBigInt < ActiveRecord::Migration[5.2]
  def change
    # Annual Budgets
    change_column :annual_budgets, :group_id, :bigint
    change_column :annual_budgets, :enterprise_id, :bigint

    # Answers
    change_column :answers, :contributing_group_id, :bigint

    # Budget Items
    change_column :budget_items, :budget_id, :bigint

    # Budgets
    #remove_foreign_key :budgets, column: :approver_id
    change_column :budgets, :approver_id, :bigint
    #add_foreign_key :budgets, :users, column: :approver_id
    change_column :budgets, :annual_budget_id, :bigint

    # Checklists
    change_column :checklists, :author_id, :bigint

    # CSV Files
    change_column :csvfiles, :user_id, :bigint
    change_column :csvfiles, :group_id, :bigint

    # Folders
    change_column :folders, :parent_id, :bigint

    # Group Categories
    change_column :group_categories, :group_category_type_id, :bigint
    change_column :group_categories, :enterprise_id, :bigint

    # Group Category Types
    change_column :group_category_types, :enterprise_id, :bigint

    # Group Leaders
    change_column :group_leaders, :group_id, :bigint
    change_column :group_leaders, :user_id, :bigint

    # Groups
    change_column :groups, :parent_id, :bigint
    change_column :groups, :group_category_id, :bigint
    change_column :groups, :group_category_type_id, :bigint

    # Initiative Comments
    change_column :initiative_comments, :initiative_id, :bigint
    change_column :initiative_comments, :user_id, :bigint

    # Initiative Expenses
    change_column :initiative_expenses, :annual_budget_id, :bigint

    # Initiative Invitees
    change_column :initiative_invitees, :initiative_id, :bigint
    change_column :initiative_invitees, :user_id, :bigint

    # Initiative Participating Groups
    change_column :initiative_participating_groups, :initiative_id, :bigint
    change_column :initiative_participating_groups, :group_id, :bigint

    # Initiative Segments
    change_column :initiative_segments, :initiative_id, :bigint
    change_column :initiative_segments, :segment_id, :bigint

    # Initiatives
    change_column :initiatives, :owner_group_id, :bigint
    change_column :initiatives, :budget_item_id, :bigint
    change_column :initiatives, :annual_budget_id, :bigint

    # News Links
    change_column :news_links, :author_id, :bigint

    # Policy Groups
    change_column :policy_groups, :user_id, :bigint

    # Social Network Posts
    change_column :social_network_posts, :author_id, :bigint
    change_column :social_network_posts, :group_id, :bigint

    # Views
    change_column :views, :user_id, :bigint
    change_column :views, :news_feed_link_id, :bigint
    change_column :views, :enterprise_id, :bigint
    change_column :views, :group_id, :bigint
    change_column :views, :folder_id, :bigint
    change_column :views, :resource_id, :bigint
  end
end
