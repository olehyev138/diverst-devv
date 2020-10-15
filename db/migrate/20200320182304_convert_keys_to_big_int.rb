class ConvertKeysToBigInt < ActiveRecord::Migration[5.2]
  def change
    # Disable foreign key checks temporarily to switch columns to bigints
    execute 'SET FOREIGN_KEY_CHECKS = 0'

    # Remove foreign keys temporarily
    remove_foreign_key "annual_budgets", column: "deprecated_enterprise_id" if foreign_key_exists?("annual_budgets", column: "deprecated_enterprise_id")
    remove_foreign_key "annual_budgets", column: "group_id" if foreign_key_exists?("annual_budgets", column: "group_id")
    remove_foreign_key "answers", column: "contributing_group_id" if foreign_key_exists?("answers", column: "contributing_group_id")
    remove_foreign_key "badges", "enterprises" if foreign_key_exists?("badges", "enterprises")
    remove_foreign_key "budget_items", "budgets" if foreign_key_exists?("budget_items", "budgets")
    remove_foreign_key "budgets", column: "requester_id" if foreign_key_exists?("budgets", column: "requester_id")
    remove_foreign_key "budgets", column: "approver_id" if foreign_key_exists?("budgets", column: "approver_id")
    remove_foreign_key "checklists", column: "author_id" if foreign_key_exists?("checklists", column: "author_id")
    remove_foreign_key "csvfiles", "users" if foreign_key_exists?("csvfiles", "users")
    remove_foreign_key "csvfiles", "groups" if foreign_key_exists?("csvfiles", "groups")
    remove_foreign_key "folders", column: "parent_id" if foreign_key_exists?("folders", column: "parent_id")
    remove_foreign_key "group_categories", "group_category_types" if foreign_key_exists?("group_categories", "group_category_types")
    remove_foreign_key "group_categories", "enterprises" if foreign_key_exists?("group_categories", "enterprises")
    remove_foreign_key "group_category_types", "enterprises" if foreign_key_exists?("group_category_types", "enterprises")
    remove_foreign_key "group_leaders", "groups" if foreign_key_exists?("group_leaders", "groups")
    remove_foreign_key "group_leaders", "users" if foreign_key_exists?("group_leaders", "users")
    remove_foreign_key "groups", column: "parent_id" if foreign_key_exists?("groups", column: "parent_id")
    remove_foreign_key "groups", "group_categories" if foreign_key_exists?("groups", "group_categories")
    remove_foreign_key "groups", "group_category_types" if foreign_key_exists?("groups", "group_category_types")
    remove_foreign_key "initiative_comments", "initiatives" if foreign_key_exists?("initiative_comments", "initiatives")
    remove_foreign_key "initiative_comments", "users" if foreign_key_exists?("initiative_comments", "users")
    remove_foreign_key "initiative_invitees", "initiatives" if foreign_key_exists?("initiative_invitees", "initiatives")
    remove_foreign_key "initiative_invitees", "users" if foreign_key_exists?("initiative_invitees", "users")
    remove_foreign_key "initiative_participating_groups", "initiatives" if foreign_key_exists?("initiative_participating_groups", "initiatives")
    remove_foreign_key "initiative_participating_groups", "groups" if foreign_key_exists?("initiative_participating_groups", "groups")
    remove_foreign_key "initiative_segments", "initiatives" if foreign_key_exists?("initiative_segments", "initiatives")
    remove_foreign_key "initiative_segments", "segments" if foreign_key_exists?("initiative_segments", "segments")
    remove_foreign_key "initiatives", column: "owner_group_id" if foreign_key_exists?("initiatives", column: "owner_group_id")
    remove_foreign_key "initiatives", "budget_items" if foreign_key_exists?("initiatives", "budget_items")
    remove_foreign_key "custom_texts", "enterprises" if foreign_key_exists?("custom_texts", "enterprises")
    remove_foreign_key "likes", "answers" if foreign_key_exists?("likes", "answers")
    remove_foreign_key "likes", "enterprises" if foreign_key_exists?("likes", "enterprises")
    remove_foreign_key "likes", "news_feed_links" if foreign_key_exists?("likes", "news_feed_links")
    remove_foreign_key "likes", "users" if foreign_key_exists?("likes", "users")
    remove_foreign_key "mentoring_session_comments", "mentoring_sessions" if foreign_key_exists?("mentoring_session_comments", "mentoring_sessions")
    remove_foreign_key "mentoring_session_comments", "users" if foreign_key_exists?("mentoring_session_comments", "users")
    remove_foreign_key "mentorship_availabilities", "users" if foreign_key_exists?("mentorship_availabilities", "users")
    remove_foreign_key "news_links", column: "author_id" if foreign_key_exists?("news_links", column: "author_id")
    remove_foreign_key "policy_groups", "users" if foreign_key_exists?("policy_groups", "users")
    remove_foreign_key "polls", "initiatives" if foreign_key_exists?("polls", "initiatives")
    remove_foreign_key "reward_actions", "enterprises" if foreign_key_exists?("reward_actions", "enterprises")
    remove_foreign_key "rewards", "enterprises" if foreign_key_exists?("rewards", "enterprises")
    remove_foreign_key "rewards", column: "responsible_id" if foreign_key_exists?("rewards", column: "responsible_id")
    remove_foreign_key "shared_metrics_dashboards", "metrics_dashboards" if foreign_key_exists?("shared_metrics_dashboards", "metrics_dashboards")
    remove_foreign_key "shared_metrics_dashboards", "users" if foreign_key_exists?("shared_metrics_dashboards", "users")
    remove_foreign_key "social_network_posts", column: "author_id" if foreign_key_exists?("social_network_posts", column: "author_id")
    remove_foreign_key "social_network_posts", "groups" if foreign_key_exists?("social_network_posts", "groups")
    remove_foreign_key "user_reward_actions", "reward_actions" if foreign_key_exists?("user_reward_actions", "reward_actions")
    remove_foreign_key "user_reward_actions", "users" if foreign_key_exists?("user_reward_actions", "users")
    remove_foreign_key "user_rewards", "rewards" if foreign_key_exists?("user_rewards", "rewards")
    remove_foreign_key "user_rewards", "users" if foreign_key_exists?("user_rewards", "users")
    remove_foreign_key "user_roles", "enterprises" if foreign_key_exists?("user_roles", "enterprises")
    remove_foreign_key "views", "users" if foreign_key_exists?("views", "users")
    remove_foreign_key "views", "news_feed_links" if foreign_key_exists?("views", "news_feed_links")
    remove_foreign_key "views", "enterprises" if foreign_key_exists?("views", "enterprises")
    remove_foreign_key "views", "groups" if foreign_key_exists?("views", "groups")
    remove_foreign_key "views", "folders" if foreign_key_exists?("views", "folders")
    remove_foreign_key "views", "resources" if foreign_key_exists?("views", "resources")

    # New table - check exists first, will exist for legacy db's - video_rooms
    if table_exists? :video_rooms
      remove_foreign_key "video_rooms", "enterprises" if foreign_key_exists?("video_rooms", "enterprises")
      remove_foreign_key "video_rooms", "initiatives" if foreign_key_exists?("video_rooms", "initiatives")
    end

    # New table - check exists first, will exist for legacy db's - video participants
    if table_exists? :video_participants
      remove_foreign_key :video_participants, :video_rooms if foreign_key_exists?(:video_participants, :video_rooms)
    end

    # New table - check exists first, will exist for legacy db's - idea_categories
    if table_exists? :idea_categories
      remove_foreign_key "idea_categories", "enterprises" if foreign_key_exists?("idea_categories", "enterprises")
    end

    # New table - check exists first, will exist for legacy db's - departments
    if table_exists? :departments
      remove_foreign_key "departments", "enterprises" if foreign_key_exists?("departments", "enterprises")
    end

    # New table - check exists first, will exist for legacy db's - suggested_hires
    if table_exists? :suggested_hires
      remove_foreign_key "suggested_hires", "users" if foreign_key_exists?("suggested_hires", "users")
      remove_foreign_key "suggested_hires", "groups" if foreign_key_exists?("suggested_hires", "groups")
    end

    # New table - check exists first, will exist for legacy db's - business_impacts
    if table_exists? :business_impacts
      remove_foreign_key "business_impacts", "enterprises" if foreign_key_exists?("business_impacts", "enterprises")
    end

    ### Primary keys

    if table_exists? :video_rooms
      change_column :video_rooms, :id, :bigint, auto_increment: true
    end

    if table_exists? :video_participants
      change_column :video_rooms, :id, :bigint, auto_increment: true
    end

    change_column :idea_categories, :id, :bigint, auto_increment: true if table_exists? :idea_categories
    change_column :departments, :id, :bigint, auto_increment: true if table_exists? :departments
    change_column :suggested_hires, :id, :bigint, auto_increment: true if table_exists? :suggested_hires
    change_column :business_impacts, :id, :bigint, auto_increment: true if table_exists? :business_impacts

    change_column :activities, :id, :bigint, auto_increment: true
    change_column :answer_comments, :id, :bigint, auto_increment: true
    change_column :answer_expenses, :id, :bigint, auto_increment: true
    change_column :answer_upvotes, :id, :bigint, auto_increment: true
    change_column :answers, :id, :bigint, auto_increment: true
    change_column :api_keys, :id, :bigint, auto_increment: true
    change_column :badges, :id, :bigint, auto_increment: true
    change_column :budget_items, :id, :bigint, auto_increment: true
    change_column :budgets, :id, :bigint, auto_increment: true
    change_column :campaign_invitations, :id, :bigint, auto_increment: true
    change_column :campaigns, :id, :bigint, auto_increment: true
    change_column :campaigns_groups, :id, :bigint, auto_increment: true
    change_column :campaigns_managers, :id, :bigint, auto_increment: true
    change_column :campaigns_segments, :id, :bigint, auto_increment: true
    change_column :checklist_items, :id, :bigint, auto_increment: true
    change_column :checklists, :id, :bigint, auto_increment: true
    change_column :ckeditor_assets, :id, :bigint, auto_increment: true
    change_column :clockwork_database_events, :id, :bigint, auto_increment: true
    change_column :csvfiles, :id, :bigint, auto_increment: true
    change_column :custom_texts, :id, :bigint, auto_increment: true
    change_column :devices, :id, :bigint, auto_increment: true
    change_column :email_variables, :id, :bigint, auto_increment: true
    change_column :emails, :id, :bigint, auto_increment: true
    change_column :enterprise_email_variables, :id, :bigint, auto_increment: true
    change_column :enterprises, :id, :bigint, auto_increment: true
    change_column :expense_categories, :id, :bigint, auto_increment: true
    change_column :expenses, :id, :bigint, auto_increment: true
    change_column :field_data, :id, :bigint, auto_increment: true
    change_column :fields, :id, :bigint, auto_increment: true
    change_column :folder_shares, :id, :bigint, auto_increment: true
    change_column :folders, :id, :bigint, auto_increment: true
    change_column :frequency_periods, :id, :bigint, auto_increment: true
    change_column :graphs, :id, :bigint, auto_increment: true
    change_column :group_categories, :id, :bigint, auto_increment: true
    change_column :group_category_types, :id, :bigint, auto_increment: true
    change_column :group_fields, :id, :bigint, auto_increment: true
    change_column :group_leaders, :id, :bigint, auto_increment: true
    change_column :group_message_comments, :id, :bigint, auto_increment: true
    change_column :group_messages, :id, :bigint, auto_increment: true
    change_column :group_messages_segments, :id, :bigint, auto_increment: true
    change_column :group_updates, :id, :bigint, auto_increment: true
    change_column :groups, :id, :bigint, auto_increment: true
    change_column :groups_metrics_dashboards, :id, :bigint, auto_increment: true
    change_column :groups_polls, :id, :bigint, auto_increment: true
    change_column :initiative_comments, :id, :bigint, auto_increment: true
    change_column :initiative_expenses, :id, :bigint, auto_increment: true
    change_column :initiative_fields, :id, :bigint, auto_increment: true
    change_column :initiative_groups, :id, :bigint, auto_increment: true
    change_column :initiative_invitees, :id, :bigint, auto_increment: true
    change_column :initiative_participating_groups, :id, :bigint, auto_increment: true
    change_column :initiative_segments, :id, :bigint, auto_increment: true
    change_column :initiative_updates, :id, :bigint, auto_increment: true
    change_column :initiative_users, :id, :bigint, auto_increment: true
    change_column :initiatives, :id, :bigint, auto_increment: true
    change_column :invitation_segments_groups, :id, :bigint, auto_increment: true
    change_column :likes, :id, :bigint, auto_increment: true
    change_column :mentoring_interests, :id, :bigint, auto_increment: true
    change_column :mentoring_request_interests, :id, :bigint, auto_increment: true
    change_column :mentoring_requests, :id, :bigint, auto_increment: true
    change_column :mentoring_session_comments, :id, :bigint, auto_increment: true
    change_column :mentoring_session_topics, :id, :bigint, auto_increment: true
    change_column :mentoring_sessions, :id, :bigint, auto_increment: true
    change_column :mentoring_types, :id, :bigint, auto_increment: true
    change_column :mentorings, :id, :bigint, auto_increment: true
    change_column :mentorship_availabilities, :id, :bigint, auto_increment: true
    change_column :mentorship_interests, :id, :bigint, auto_increment: true
    change_column :mentorship_ratings, :id, :bigint, auto_increment: true
    change_column :mentorship_sessions, :id, :bigint, auto_increment: true
    change_column :mentorship_types, :id, :bigint, auto_increment: true
    change_column :metrics_dashboards, :id, :bigint, auto_increment: true
    change_column :metrics_dashboards_segments, :id, :bigint, auto_increment: true
    change_column :mobile_fields, :id, :bigint, auto_increment: true
    change_column :news_feed_link_segments, :id, :bigint, auto_increment: true
    change_column :news_feed_links, :id, :bigint, auto_increment: true
    change_column :news_feeds, :id, :bigint, auto_increment: true
    change_column :news_link_comments, :id, :bigint, auto_increment: true
    change_column :news_link_photos, :id, :bigint, auto_increment: true
    change_column :news_link_segments, :id, :bigint, auto_increment: true
    change_column :news_links, :id, :bigint, auto_increment: true
    change_column :outcomes, :id, :bigint, auto_increment: true
    change_column :pillars, :id, :bigint, auto_increment: true
    change_column :policy_group_templates, :id, :bigint, auto_increment: true
    change_column :policy_groups, :id, :bigint, auto_increment: true
    change_column :poll_responses, :id, :bigint, auto_increment: true
    change_column :polls, :id, :bigint, auto_increment: true
    change_column :polls_segments, :id, :bigint, auto_increment: true
    change_column :questions, :id, :bigint, auto_increment: true
    change_column :resources, :id, :bigint, auto_increment: true
    change_column :reward_actions, :id, :bigint, auto_increment: true
    change_column :rewards, :id, :bigint, auto_increment: true
    change_column :samples, :id, :bigint, auto_increment: true
    change_column :segment_field_rules, :id, :bigint, auto_increment: true
    change_column :segment_group_scope_rule_groups, :id, :bigint, auto_increment: true
    change_column :segment_group_scope_rules, :id, :bigint, auto_increment: true
    change_column :segment_order_rules, :id, :bigint, auto_increment: true
    change_column :segments, :id, :bigint, auto_increment: true
    change_column :sessions, :id, :bigint, auto_increment: true
    change_column :shared_metrics_dashboards, :id, :bigint, auto_increment: true
    change_column :shared_news_feed_links, :id, :bigint, auto_increment: true
    change_column :social_link_segments, :id, :bigint, auto_increment: true
    change_column :social_network_posts, :id, :bigint, auto_increment: true
    change_column :sponsors, :id, :bigint, auto_increment: true
    change_column :survey_managers, :id, :bigint, auto_increment: true
    change_column :tags, :id, :bigint, auto_increment: true
    change_column :themes, :id, :bigint, auto_increment: true
    change_column :topic_feedbacks, :id, :bigint, auto_increment: true
    change_column :topics, :id, :bigint, auto_increment: true
    change_column :twitter_accounts, :id, :bigint, auto_increment: true
    change_column :user_groups, :id, :bigint, auto_increment: true
    change_column :user_reward_actions, :id, :bigint, auto_increment: true
    change_column :user_rewards, :id, :bigint, auto_increment: true
    change_column :user_roles, :id, :bigint, auto_increment: true
    change_column :users, :id, :bigint, auto_increment: true
    change_column :users_segments, :id, :bigint, auto_increment: true
    change_column :views, :id, :bigint, auto_increment: true
    change_column :yammer_field_mappings, :id, :bigint, auto_increment: true

    ### Foreign Keys

    # Answers
    change_column :answers, :contributing_group_id, :bigint

    # Budget Items
    change_column :budget_items, :budget_id, :bigint

    # Budgets
    change_column :budgets, :approver_id, :bigint

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


    change_column :answers, :contributing_group_id, :bigint
    change_column :badges, :enterprise_id, :bigint
    change_column :budget_items, :budget_id, :bigint
    change_column :budgets, :requester_id, :bigint
    change_column :budgets, :approver_id, :bigint
    change_column :checklists, :author_id, :bigint
    change_column :csvfiles, :user_id, :bigint
    change_column :csvfiles, :group_id, :bigint
    change_column :folders, :parent_id, :bigint
    change_column :group_categories, :group_category_type_id, :bigint
    change_column :group_categories, :enterprise_id, :bigint
    change_column :group_category_types, :enterprise_id, :bigint
    change_column :group_leaders, :group_id, :bigint
    change_column :group_leaders, :user_id, :bigint
    change_column :groups, :parent_id, :bigint
    change_column :groups, :group_category_id, :bigint
    change_column :groups, :group_category_type_id, :bigint
    change_column :initiative_comments, :initiative_id, :bigint
    change_column :initiative_comments, :user_id, :bigint
    change_column :initiative_invitees, :initiative_id, :bigint
    change_column :initiative_invitees, :user_id, :bigint
    change_column :initiative_participating_groups, :initiative_id, :bigint
    change_column :initiative_participating_groups, :group_id, :bigint
    change_column :initiative_segments, :initiative_id, :bigint
    change_column :initiative_segments, :segment_id, :bigint
    change_column :initiatives, :owner_group_id, :bigint
    change_column :initiatives, :budget_item_id, :bigint
    change_column :custom_texts, :enterprise_id, :bigint
    change_column :likes, :answer_id, :bigint
    change_column :likes, :enterprise_id, :bigint
    change_column :likes, :news_feed_link_id, :bigint
    change_column :likes, :user_id, :bigint
    change_column :mentoring_session_comments, :mentoring_session_id, :bigint
    change_column :mentoring_session_comments, :user_id, :bigint
    change_column :mentorship_availabilities, :user_id, :bigint
    change_column :news_links, :author_id, :bigint
    change_column :policy_groups, :user_id, :bigint
    change_column :polls, :initiative_id, :bigint
    change_column :reward_actions, :enterprise_id, :bigint
    change_column :rewards, :enterprise_id, :bigint
    change_column :rewards, :responsible_id, :bigint
    change_column :shared_metrics_dashboards, :metrics_dashboard_id, :bigint
    change_column :shared_metrics_dashboards, :user_id, :bigint
    change_column :social_network_posts, :author_id, :bigint
    change_column :social_network_posts, :group_id, :bigint
    change_column :user_reward_actions, :reward_action_id, :bigint
    change_column :user_reward_actions, :user_id, :bigint
    change_column :user_rewards, :reward_id, :bigint
    change_column :user_rewards, :user_id, :bigint
    change_column :user_roles, :enterprise_id, :bigint
    change_column :views, :user_id, :bigint
    change_column :views, :news_feed_link_id, :bigint
    change_column :views, :enterprise_id, :bigint
    change_column :views, :group_id, :bigint
    change_column :views, :folder_id, :bigint
    change_column :views, :resource_id, :bigint

    if table_exists? :video_rooms
      change_column :video_rooms, :enterprise_id, :bigint
      change_column :video_rooms, :initiative_id, :bigint
    end

    if table_exists? :video_participants
      change_column :video_participants, :video_room_id, :bigint
    end

    if table_exists? :suggested_hires
      change_column :suggested_hires, :user_id, :bigint
      change_column :suggested_hires, :group_id, :bigint
    end

    change_column :idea_categories, :enterprise_id, :bigint if table_exists? :idea_categories
    change_column :departments, :enterprise_id, :bigint if table_exists? :departments
    change_column :business_impacts, :enterprise_id, :bigint if table_exists? :business_impacts

    add_foreign_key "answers", "groups", column: "contributing_group_id"
    add_foreign_key "badges", "enterprises"
    add_foreign_key "budget_items", "budgets"
    add_foreign_key "budgets", "users", column: "requester_id"
    add_foreign_key "budgets", "users", column: "approver_id"
    add_foreign_key "checklists", "users", column: "author_id"
    add_foreign_key "csvfiles", "users"
    add_foreign_key "csvfiles", "groups"
    add_foreign_key "folders", "folders", column: "parent_id"
    add_foreign_key "group_categories", "group_category_types"
    add_foreign_key "group_categories", "enterprises"
    add_foreign_key "group_category_types", "enterprises"
    add_foreign_key "group_leaders", "groups"
    add_foreign_key "group_leaders", "users"
    add_foreign_key "groups", "groups", column: "parent_id"
    add_foreign_key "groups", "group_categories"
    add_foreign_key "groups", "group_category_types"
    add_foreign_key "initiative_comments", "initiatives"
    add_foreign_key "initiative_comments", "users"
    add_foreign_key "initiative_invitees", "initiatives"
    add_foreign_key "initiative_invitees", "users"
    add_foreign_key "initiative_participating_groups", "initiatives"
    add_foreign_key "initiative_participating_groups", "groups"
    add_foreign_key "initiative_segments", "initiatives"
    add_foreign_key "initiative_segments", "segments"
    add_foreign_key "initiatives", "groups", column: "owner_group_id"
    add_foreign_key "initiatives", "budget_items"
    add_foreign_key "custom_texts", "enterprises"
    add_foreign_key "likes", "answers"
    add_foreign_key "likes", "enterprises"
    add_foreign_key "likes", "news_feed_links"
    add_foreign_key "likes", "users"
    add_foreign_key "mentoring_session_comments", "mentoring_sessions"
    add_foreign_key "mentoring_session_comments", "users"
    add_foreign_key "mentorship_availabilities", "users"
    add_foreign_key "news_links", "users", column: "author_id"
    add_foreign_key "policy_groups", "users"
    add_foreign_key "polls", "initiatives"
    add_foreign_key "reward_actions", "enterprises"
    add_foreign_key "rewards", "enterprises"
    add_foreign_key "rewards", "users", column: "responsible_id"
    add_foreign_key "shared_metrics_dashboards", "metrics_dashboards"
    add_foreign_key "shared_metrics_dashboards", "users"
    add_foreign_key "social_network_posts", "users", column: "author_id"
    add_foreign_key "social_network_posts", "groups"
    add_foreign_key "user_reward_actions", "reward_actions"
    add_foreign_key "user_reward_actions", "users"
    add_foreign_key "user_rewards", "rewards"
    add_foreign_key "user_rewards", "users"
    add_foreign_key "user_roles", "enterprises"
    add_foreign_key "views", "users"
    add_foreign_key "views", "news_feed_links"
    add_foreign_key "views", "enterprises"
    add_foreign_key "views", "groups"
    add_foreign_key "views", "folders"
    add_foreign_key "views", "resources"

    if table_exists? :video_rooms
      add_foreign_key "video_rooms", "enterprises"
      add_foreign_key "video_rooms", "initiatives"
    end

    if table_exists? :video_participants
      add_foreign_key :video_participants, :video_rooms
    end

    if table_exists? :suggested_hires
      add_foreign_key :suggested_hires, :users
      add_foreign_key :suggested_hires, :groups
    end

    add_foreign_key :idea_categories, :enterprises if table_exists? :idea_categories
    add_foreign_key :departments, :enterprises if table_exists? :departments
    add_foreign_key :business_impacts, :enterprises if table_exists? :business_impacts

    # Re-enable foreign key checks
    # execute 'SET FOREIGN_KEY_CHECKS = 1'
  end
end
