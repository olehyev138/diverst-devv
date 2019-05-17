# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_02_185618) do

  create_table "activities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "trackable_id"
    t.string "trackable_type", collation: "utf8mb4_unicode_ci"
    t.integer "owner_id"
    t.string "owner_type", collation: "utf8mb4_unicode_ci"
    t.string "key", collation: "utf8mb4_unicode_ci"
    t.text "parameters", collation: "utf8mb4_unicode_ci"
    t.integer "recipient_id"
    t.string "recipient_type", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "answer_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.integer "author_id"
    t.integer "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
  end

  create_table "answer_expenses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "answer_id"
    t.integer "expense_id"
    t.integer "quantity"
  end

  create_table "answer_upvotes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "author_id"
    t.integer "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "question_id"
    t.integer "author_id"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "chosen"
    t.integer "upvote_count", default: 0
    t.text "outcome", collation: "utf8mb4_unicode_ci"
    t.integer "value"
    t.integer "benefit_type"
    t.string "supporting_document_file_name", collation: "utf8mb4_unicode_ci"
    t.string "supporting_document_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "supporting_document_file_size"
    t.datetime "supporting_document_updated_at"
    t.integer "contributing_group_id"
    t.index ["contributing_group_id"], name: "index_answers_on_contributing_group_id"
  end

  create_table "badges", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id", null: false
    t.integer "points", null: false
    t.string "label", collation: "utf8mb4_unicode_ci"
    t.string "image_file_name", collation: "utf8mb4_unicode_ci"
    t.string "image_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "image_file_size", null: false
    t.datetime "image_updated_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["enterprise_id"], name: "index_badges_on_enterprise_id"
  end

  create_table "budget_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "budget_id"
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.date "estimated_date"
    t.boolean "is_private", default: false
    t.boolean "is_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "estimated_amount", precision: 8, scale: 2
    t.decimal "available_amount", precision: 8, scale: 2, default: "0.0"
  end

  create_table "budgets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.boolean "is_approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "approver_id"
    t.integer "requester_id"
    t.integer "group_id"
    t.text "comments"
    t.string "decline_reason"
    t.index ["approver_id"], name: "fk_rails_a057b1443a"
    t.index ["requester_id"], name: "fk_rails_d21f6fbcce"
  end

  create_table "campaign_invitations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "user_id"
    t.integer "response", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_sent", default: false
  end

  create_table "campaigns", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.datetime "start"
    t.datetime "end"
    t.integer "nb_invites"
    t.integer "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name", collation: "utf8mb4_unicode_ci"
    t.string "image_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "banner_file_name", collation: "utf8mb4_unicode_ci"
    t.string "banner_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
    t.integer "owner_id"
    t.integer "status", default: 0
  end

  create_table "campaigns_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "group_id"
  end

  create_table "campaigns_managers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "user_id"
  end

  create_table "campaigns_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "segment_id"
  end

  create_table "checklist_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.boolean "is_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "initiative_id"
    t.integer "checklist_id"
  end

  create_table "checklists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "budget_id"
    t.integer "initiative_id"
  end

  create_table "ckeditor_assets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "data_file_name", collation: "utf8mb4_unicode_ci"
    t.string "data_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "data_file_size"
    t.string "data_fingerprint", collation: "utf8mb4_unicode_ci"
    t.string "type", limit: 30, collation: "utf8mb4_unicode_ci"
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clockwork_database_events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "frequency_quantity", default: 1, null: false
    t.integer "frequency_period_id", null: false
    t.integer "enterprise_id", null: false
    t.boolean "disabled", default: false
    t.string "day"
    t.string "at"
    t.string "job_name", null: false
    t.string "method_name", null: false
    t.string "method_args"
    t.string "tz", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["frequency_period_id"], name: "index_clockwork_database_events_on_frequency_period_id"
  end

  create_table "csvfiles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "import_file_file_name"
    t.string "import_file_content_type"
    t.integer "import_file_file_size"
    t.datetime "import_file_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "group_id"
    t.string "download_file_file_name"
    t.string "download_file_content_type"
    t.integer "download_file_file_size"
    t.datetime "download_file_updated_at"
    t.string "download_file_name"
  end

  create_table "custom_texts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "erg", default: "Group"
    t.integer "enterprise_id"
    t.string "program", default: "Goal"
    t.string "structure", default: "Structure"
    t.string "outcome", default: "Focus Areas"
    t.string "badge", default: "Badge"
    t.string "segment", default: "Segment"
    t.string "dci_full_title", default: "Engagement"
    t.string "dci_abbreviation", default: "Engagement"
    t.string "member_preference", default: "Member Survey"
    t.string "parent", default: "Parent"
    t.string "sub_erg", default: "Sub-Group"
    t.string "privacy_statement", default: "Privacy Statement"
    t.index ["enterprise_id"], name: "index_custom_texts_on_enterprise_id"
  end

  create_table "email_variables", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enterprise_email_variable_id"
    t.boolean "downcase", default: false
    t.boolean "upcase", default: false
    t.boolean "titleize", default: false
    t.boolean "pluralize", default: false
  end

  create_table "emails", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.integer "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject", collation: "utf8mb4_unicode_ci"
    t.text "content", null: false
    t.string "mailer_name", null: false
    t.string "mailer_method", null: false
    t.string "template"
    t.string "description", null: false
  end

  create_table "enterprise_email_variables", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "key"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "example"
  end

  create_table "enterprises", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.string "sp_entity_id", collation: "utf8mb4_unicode_ci"
    t.string "idp_entity_id", collation: "utf8mb4_unicode_ci"
    t.string "idp_sso_target_url", collation: "utf8mb4_unicode_ci"
    t.string "idp_slo_target_url", collation: "utf8mb4_unicode_ci"
    t.text "idp_cert", collation: "utf8mb4_unicode_ci"
    t.string "saml_first_name_mapping", collation: "utf8mb4_unicode_ci"
    t.string "saml_last_name_mapping", collation: "utf8mb4_unicode_ci"
    t.boolean "has_enabled_saml"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "yammer_token", collation: "utf8mb4_unicode_ci"
    t.boolean "yammer_import", default: false
    t.boolean "yammer_group_sync", default: false
    t.integer "theme_id"
    t.string "cdo_picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "cdo_picture_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "cdo_picture_file_size"
    t.datetime "cdo_picture_updated_at"
    t.text "cdo_message", collation: "utf8mb4_unicode_ci"
    t.boolean "collaborate_module_enabled", default: true, null: false
    t.boolean "scope_module_enabled", default: true, null: false
    t.boolean "plan_module_enabled", default: true, null: false
    t.string "banner_file_name", collation: "utf8mb4_unicode_ci"
    t.string "banner_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
    t.text "home_message"
    t.text "privacy_statement", collation: "utf8mb4_unicode_ci"
    t.boolean "has_enabled_onboarding_email", default: true
    t.string "xml_sso_config_file_name", collation: "utf8mb4_unicode_ci"
    t.string "xml_sso_config_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "xml_sso_config_file_size"
    t.datetime "xml_sso_config_updated_at"
    t.string "iframe_calendar_token", collation: "utf8mb4_unicode_ci"
    t.string "time_zone", collation: "utf8mb4_unicode_ci"
    t.boolean "enable_rewards", default: false
    t.string "company_video_url"
    t.string "onboarding_sponsor_media_file_name"
    t.string "onboarding_sponsor_media_content_type"
    t.integer "onboarding_sponsor_media_file_size"
    t.datetime "onboarding_sponsor_media_updated_at"
    t.boolean "enable_pending_comments", default: false
    t.boolean "mentorship_module_enabled", default: false
    t.boolean "disable_likes", default: false
    t.string "default_from_email_address"
    t.string "default_from_email_display_name"
    t.boolean "enable_social_media", default: false
    t.boolean "redirect_all_emails", default: false
    t.string "redirect_email_contact"
    t.boolean "disable_emails", default: false
    t.integer "expiry_age_for_resources", default: 0
    t.string "unit_of_expiry_age"
    t.boolean "auto_archive", default: false
  end

  create_table "expense_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.string "icon_file_name", collation: "utf8mb4_unicode_ci"
    t.string "icon_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.integer "price"
    t.boolean "income", default: false
    t.integer "category_id"
  end

  create_table "fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "type", collation: "utf8mb4_unicode_ci"
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.integer "gamification_value", default: 1
    t.boolean "show_on_vcard"
    t.string "saml_attribute", collation: "utf8mb4_unicode_ci"
    t.text "options_text", collation: "utf8mb4_unicode_ci"
    t.integer "min"
    t.integer "max"
    t.boolean "match_exclude"
    t.boolean "match_polarity"
    t.float "match_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alternative_layout", default: false
    t.boolean "private", default: false
    t.boolean "elasticsearch_only", default: false
    t.boolean "required", default: false
    t.string "field_type", collation: "utf8mb4_unicode_ci"
    t.integer "enterprise_id"
    t.integer "group_id"
    t.integer "poll_id"
    t.integer "initiative_id"
  end

  create_table "folder_shares", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "folder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enterprise_id"
    t.integer "group_id"
  end

  create_table "folders", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "password_protected", default: false
    t.string "password_digest"
    t.integer "parent_id"
    t.integer "enterprise_id"
    t.integer "group_id"
  end

  create_table "frequency_periods", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: "daily", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "field_id"
    t.integer "aggregation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_field", collation: "utf8mb4_unicode_ci"
    t.string "custom_aggregation", collation: "utf8mb4_unicode_ci"
    t.boolean "time_series", default: false
    t.datetime "range_from"
    t.datetime "range_to"
    t.integer "metrics_dashboard_id"
    t.integer "poll_id"
  end

  create_table "group_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_category_type_id"
    t.integer "enterprise_id"
  end

  create_table "group_category_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enterprise_id"
  end

  create_table "group_fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_id"
    t.integer "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_leaders", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.string "position_name", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true
    t.boolean "pending_member_notifications_enabled", default: false
    t.boolean "pending_comments_notifications_enabled", default: false
    t.boolean "pending_posts_notifications_enabled", default: false
    t.boolean "default_group_contact", default: false
    t.integer "user_role_id"
    t.boolean "groups_budgets_index", default: false, null: false
    t.boolean "initiatives_manage", default: false, null: false
    t.boolean "groups_manage", default: false, null: false
    t.boolean "initiatives_create", default: false
    t.boolean "groups_budgets_request", default: false
    t.boolean "group_messages_manage", default: false
    t.boolean "group_messages_index", default: false
    t.boolean "group_messages_create", default: false
    t.boolean "news_links_index", default: false
    t.boolean "news_links_create", default: false
    t.boolean "news_links_manage", default: false
    t.boolean "social_links_index", default: false
    t.boolean "social_links_create", default: false
    t.boolean "social_links_manage", default: false
    t.boolean "group_leader_index", default: false
    t.boolean "group_leader_manage", default: false
    t.boolean "groups_members_index", default: false
    t.boolean "groups_members_manage", default: false
    t.boolean "groups_insights_manage", default: false
    t.boolean "groups_layouts_manage", default: false
    t.boolean "group_settings_manage", default: false
    t.boolean "group_resources_index", default: false
    t.boolean "group_resources_create", default: false
    t.boolean "group_resources_manage", default: false
    t.boolean "group_posts_index", default: false
    t.boolean "budget_approval", default: false
    t.boolean "groups_budgets_manage", default: false
    t.boolean "manage_posts", default: false
    t.boolean "initiatives_index", default: false
    t.integer "position"
  end

  create_table "group_message_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.integer "author_id"
    t.integer "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
  end

  create_table "group_messages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_id"
    t.string "subject", collation: "utf8mb4_unicode_ci"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
  end

  create_table "group_messages_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_message_id"
    t.integer "segment_id"
  end

  create_table "group_updates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.text "comments", collation: "utf8mb4_unicode_ci"
    t.integer "owner_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_file_name", collation: "utf8mb4_unicode_ci"
    t.string "logo_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean "send_invitations"
    t.integer "participation_score_7days"
    t.boolean "yammer_create_group"
    t.boolean "yammer_group_created"
    t.string "yammer_group_name", collation: "utf8mb4_unicode_ci"
    t.boolean "yammer_sync_users"
    t.string "yammer_group_link"
    t.integer "yammer_id"
    t.integer "manager_id"
    t.integer "owner_id"
    t.integer "lead_manager_id"
    t.string "pending_users", collation: "utf8mb4_unicode_ci"
    t.string "members_visibility", collation: "utf8mb4_unicode_ci"
    t.string "messages_visibility", collation: "utf8mb4_unicode_ci"
    t.decimal "annual_budget", precision: 8, scale: 2
    t.decimal "leftover_money", precision: 8, scale: 2, default: "0.0"
    t.string "banner_file_name", collation: "utf8mb4_unicode_ci"
    t.string "banner_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
    t.string "calendar_color", collation: "utf8mb4_unicode_ci"
    t.integer "total_weekly_points", default: 0
    t.boolean "active", default: true
    t.integer "parent_id"
    t.string "sponsor_image_file_name"
    t.string "sponsor_image_content_type"
    t.integer "sponsor_image_file_size"
    t.datetime "sponsor_image_updated_at"
    t.string "company_video_url"
    t.string "latest_news_visibility"
    t.string "upcoming_events_visibility"
    t.integer "group_category_id"
    t.integer "group_category_type_id"
    t.boolean "private", default: false
    t.text "short_description"
    t.string "layout"
    t.text "home_message"
    t.boolean "default_mentor_group", default: false
    t.integer "position"
    t.integer "expiry_age_for_news", default: 0
    t.integer "expiry_age_for_resources", default: 0
    t.integer "expiry_age_for_events", default: 0
    t.string "unit_of_expiry_age"
    t.boolean "auto_archive", default: false
  end

  create_table "groups_metrics_dashboards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_id"
    t.integer "metrics_dashboard_id"
  end

  create_table "groups_polls", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_id"
    t.integer "poll_id"
  end

  create_table "initiative_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "user_id"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "initiative_expenses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "description", collation: "utf8mb4_unicode_ci"
    t.integer "amount"
    t.integer "owner_id"
    t.integer "initiative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "initiative_fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "field_id"
  end

  create_table "initiative_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "group_id"
  end

  create_table "initiative_invitees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "user_id"
  end

  create_table "initiative_participating_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "group_id"
  end

  create_table "initiative_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "segment_id"
  end

  create_table "initiative_updates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.text "comments", collation: "utf8mb4_unicode_ci"
    t.integer "owner_id"
    t.integer "initiative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "report_date"
  end

  create_table "initiative_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "initiatives", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.datetime "start"
    t.datetime "end"
    t.decimal "estimated_funding", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "actual_funding"
    t.integer "owner_id"
    t.integer "pillar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.integer "max_attendees"
    t.string "picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "picture_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer "owner_group_id"
    t.string "location", collation: "utf8mb4_unicode_ci"
    t.integer "budget_item_id"
    t.boolean "finished_expenses", default: false
    t.datetime "archived_at"
  end

  create_table "invitation_segments_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "segment_id"
    t.integer "group_id"
  end

  create_table "likes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "news_feed_link_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enterprise_id"
    t.integer "answer_id"
    t.index ["answer_id"], name: "index_likes_on_answer_id"
    t.index ["enterprise_id"], name: "index_likes_on_enterprise_id"
    t.index ["news_feed_link_id"], name: "index_likes_on_news_feed_link_id"
    t.index ["user_id", "answer_id", "enterprise_id"], name: "index_likes_on_user_id_and_answer_id_and_enterprise_id", unique: true
    t.index ["user_id", "news_feed_link_id", "enterprise_id"], name: "index_likes_on_user_id_and_news_feed_link_id_and_enterprise_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "mentoring_interests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_request_interests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "mentoring_request_id", null: false
    t.integer "mentoring_interest_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_requests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "status", default: "pending", null: false
    t.text "notes"
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "mentoring_type", default: "mentor", null: false
  end

  create_table "mentoring_session_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "mentoring_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_session_id"], name: "index_mentoring_session_comments_on_mentoring_session_id"
    t.index ["user_id"], name: "index_mentoring_session_comments_on_user_id"
  end

  create_table "mentoring_session_topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "mentoring_interest_id", null: false
    t.integer "mentoring_session_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.integer "creator_id", null: false
    t.datetime "start", null: false
    t.datetime "end", null: false
    t.string "format", null: false
    t.string "link"
    t.text "access_token"
    t.string "video_room_name"
    t.string "status", default: "scheduled", null: false
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "mentor_id"
    t.integer "mentee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorship_availabilities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "start", null: false
    t.string "end", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "day", default: "monday", null: false
    t.index ["user_id"], name: "index_mentorship_availabilities_on_user_id"
  end

  create_table "mentorship_interests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "mentoring_interest_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorship_ratings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "rating", null: false
    t.integer "user_id", null: false
    t.integer "mentoring_session_id", null: false
    t.boolean "okrs_achieved", default: false
    t.boolean "valuable", default: false
    t.text "comments", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorship_sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "role", null: false
    t.integer "mentoring_session_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status", default: "pending", null: false
  end

  create_table "mentorship_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "mentoring_type_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metrics_dashboards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "shareable_token"
  end

  create_table "metrics_dashboards_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "metrics_dashboard_id"
    t.integer "segment_id"
  end

  create_table "mobile_fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.integer "field_id"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_feed_link_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "news_feed_link_id"
    t.integer "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "news_link_segment_id"
    t.integer "group_messages_segment_id"
    t.integer "social_link_segment_id"
  end

  create_table "news_feed_links", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "news_feed_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "news_link_id"
    t.integer "group_message_id"
    t.integer "social_link_id"
    t.boolean "is_pinned", default: false
    t.datetime "archived_at"
  end

  create_table "news_feeds", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_link_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.integer "author_id"
    t.integer "news_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
  end

  create_table "news_link_photos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "news_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_link_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "news_link_id"
    t.integer "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_links", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description"
    t.string "url", collation: "utf8mb4_unicode_ci"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "picture_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer "author_id"
  end

  create_table "outcomes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pillars", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.string "value_proposition", collation: "utf8mb4_unicode_ci"
    t.integer "outcome_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "policy_group_templates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "default", default: false
    t.integer "user_role_id"
    t.integer "enterprise_id"
    t.boolean "campaigns_index", default: false
    t.boolean "campaigns_create", default: false
    t.boolean "campaigns_manage", default: false
    t.boolean "polls_index", default: false
    t.boolean "polls_create", default: false
    t.boolean "polls_manage", default: false
    t.boolean "group_messages_index", default: false
    t.boolean "group_messages_create", default: false
    t.boolean "group_messages_manage", default: false
    t.boolean "groups_index", default: false
    t.boolean "groups_create", default: false
    t.boolean "groups_manage", default: false
    t.boolean "groups_members_index", default: false
    t.boolean "groups_members_manage", default: false
    t.boolean "groups_budgets_index", default: false
    t.boolean "groups_budgets_request", default: false
    t.boolean "metrics_dashboards_index", default: false
    t.boolean "metrics_dashboards_create", default: false
    t.boolean "news_links_index", default: false
    t.boolean "news_links_create", default: false
    t.boolean "news_links_manage", default: false
    t.boolean "enterprise_resources_index", default: false
    t.boolean "enterprise_resources_create", default: false
    t.boolean "enterprise_resources_manage", default: false
    t.boolean "segments_index", default: false
    t.boolean "segments_create", default: false
    t.boolean "segments_manage", default: false
    t.boolean "users_index", default: false
    t.boolean "users_manage", default: false
    t.boolean "initiatives_index", default: false
    t.boolean "initiatives_create", default: false
    t.boolean "initiatives_manage", default: false
    t.boolean "logs_view", default: false
    t.boolean "branding_manage", default: false
    t.boolean "sso_manage", default: false
    t.boolean "permissions_manage", default: false
    t.boolean "group_leader_manage", default: false
    t.boolean "global_calendar", default: false
    t.boolean "manage_posts", default: false
    t.boolean "diversity_manage", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "budget_approval", default: false
    t.boolean "manage_all", default: false
    t.boolean "enterprise_manage", default: false
    t.boolean "groups_budgets_manage", default: false
    t.boolean "group_leader_index", default: false
    t.boolean "groups_insights_manage", default: false
    t.boolean "groups_layouts_manage", default: false
    t.boolean "group_resources_index", default: false
    t.boolean "group_resources_create", default: false
    t.boolean "group_resources_manage", default: false
    t.boolean "social_links_index", default: false
    t.boolean "social_links_create", default: false
    t.boolean "social_links_manage", default: false
    t.boolean "group_settings_manage", default: false
    t.boolean "group_posts_index", default: false
    t.boolean "mentorship_manage", default: false
    t.boolean "auto_archive_manage", default: false
  end

  create_table "policy_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "campaigns_index", default: false
    t.boolean "campaigns_create", default: false
    t.boolean "campaigns_manage", default: false
    t.boolean "polls_index", default: false
    t.boolean "polls_create", default: false
    t.boolean "polls_manage", default: false
    t.boolean "group_messages_index", default: false
    t.boolean "group_messages_create", default: false
    t.boolean "group_messages_manage", default: false
    t.boolean "groups_index", default: false
    t.boolean "groups_create", default: false
    t.boolean "groups_manage", default: false
    t.boolean "groups_members_index", default: false
    t.boolean "groups_members_manage", default: false
    t.boolean "groups_budgets_index", default: false
    t.boolean "groups_budgets_request", default: false
    t.boolean "metrics_dashboards_index", default: false
    t.boolean "metrics_dashboards_create", default: false
    t.boolean "news_links_index", default: false
    t.boolean "news_links_create", default: false
    t.boolean "news_links_manage", default: false
    t.boolean "enterprise_resources_index", default: false
    t.boolean "enterprise_resources_create", default: false
    t.boolean "enterprise_resources_manage", default: false
    t.boolean "segments_index", default: false
    t.boolean "segments_create", default: false
    t.boolean "segments_manage", default: false
    t.boolean "users_index", default: false
    t.boolean "users_manage", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "initiatives_index", default: false
    t.boolean "initiatives_create", default: false
    t.boolean "initiatives_manage", default: false
    t.boolean "budget_approval", default: false
    t.boolean "logs_view", default: false
    t.boolean "sso_manage", default: false
    t.boolean "permissions_manage", default: false
    t.boolean "diversity_manage", default: false
    t.boolean "manage_posts", default: false
    t.boolean "group_leader_manage", default: false
    t.boolean "global_calendar", default: false
    t.boolean "branding_manage", default: false
    t.integer "user_id"
    t.boolean "manage_all", default: false
    t.boolean "enterprise_manage", default: false
    t.boolean "groups_budgets_manage", default: false
    t.boolean "group_leader_index", default: false
    t.boolean "groups_insights_manage", default: false
    t.boolean "groups_layouts_manage", default: false
    t.boolean "group_resources_index", default: false
    t.boolean "group_resources_create", default: false
    t.boolean "group_resources_manage", default: false
    t.boolean "social_links_index", default: false
    t.boolean "social_links_create", default: false
    t.boolean "social_links_manage", default: false
    t.boolean "group_settings_manage", default: false
    t.boolean "group_posts_index", default: false
    t.boolean "mentorship_manage", default: false
    t.boolean "auto_archive_manage", default: false
    t.index ["user_id"], name: "index_policy_groups_on_user_id"
  end

  create_table "poll_responses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "poll_id"
    t.integer "user_id"
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "anonymous", default: false
    t.index ["user_id"], name: "index_poll_responses_on_user_id"
  end

  create_table "polls", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.time "start"
    t.time "end"
    t.integer "nb_invitations"
    t.integer "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.integer "status", default: 0, null: false
    t.boolean "email_sent", default: false, null: false
    t.integer "initiative_id"
    t.index ["initiative_id"], name: "index_polls_on_initiative_id"
  end

  create_table "polls_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "poll_id"
    t.integer "segment_id"
  end

  create_table "questions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.integer "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "solved_at"
    t.text "conclusion", collation: "utf8mb4_unicode_ci"
  end

  create_table "resources", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name", collation: "utf8mb4_unicode_ci"
    t.string "file_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "owner_id"
    t.string "resource_type"
    t.string "url", limit: 255
    t.integer "mentoring_session_id"
    t.integer "enterprise_id"
    t.integer "folder_id"
    t.integer "group_id"
    t.integer "initiative_id"
    t.datetime "archived_at"
  end

  create_table "reward_actions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "label", collation: "utf8mb4_unicode_ci"
    t.integer "points"
    t.string "key", collation: "utf8mb4_unicode_ci"
    t.integer "enterprise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["enterprise_id"], name: "index_reward_actions_on_enterprise_id"
  end

  create_table "rewards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id", null: false
    t.integer "points", null: false
    t.string "label", collation: "utf8mb4_unicode_ci"
    t.string "picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "picture_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.integer "responsible_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["enterprise_id"], name: "index_rewards_on_enterprise_id"
    t.index ["responsible_id"], name: "index_rewards_on_responsible_id"
  end

  create_table "samples", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_samples_on_user_id"
  end

  create_table "segment_group_scope_rule_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "segment_group_scope_rule_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_segment_group_scope_rule_groups_on_group_id"
    t.index ["segment_group_scope_rule_id"], name: "segment_group_rule_group_index"
  end

  create_table "segment_group_scope_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "segment_id"
    t.integer "operator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segment_id"], name: "index_segment_group_scope_rules_on_segment_id"
  end

  create_table "segment_order_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operator", null: false
    t.integer "field", null: false
    t.index ["segment_id"], name: "index_segment_order_rules_on_segment_id"
  end

  create_table "segment_rules", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "segment_id"
    t.integer "field_id"
    t.integer "operator"
    t.text "values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "active_users_filter", collation: "utf8mb4_unicode_ci"
    t.integer "limit"
    t.integer "job_status", default: 0, null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_segments_on_parent_id"
  end

  create_table "shared_metrics_dashboards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "metrics_dashboard_id"
    t.index ["metrics_dashboard_id"], name: "index_shared_metrics_dashboards_on_metrics_dashboard_id"
    t.index ["user_id"], name: "index_shared_metrics_dashboards_on_user_id"
  end

  create_table "shared_news_feed_links", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "news_feed_link_id", null: false
    t.integer "news_feed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_link_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "social_link_id"
    t.integer "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_network_posts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "author_id"
    t.text "embed_code", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", collation: "utf8mb4_unicode_ci"
    t.integer "group_id"
  end

  create_table "sponsors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "sponsor_name"
    t.string "sponsor_title"
    t.text "sponsor_message"
    t.boolean "disable_sponsor_message"
    t.integer "sponsorable_id"
    t.string "sponsorable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sponsor_media_file_name"
    t.string "sponsor_media_content_type"
    t.integer "sponsor_media_file_size"
    t.datetime "sponsor_media_updated_at"
    t.index ["sponsorable_type", "sponsorable_id"], name: "index_sponsors_on_sponsorable_type_and_sponsorable_id"
  end

  create_table "survey_managers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "survey_id"
    t.integer "user_id"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "resource_id"
  end

  create_table "themes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "logo_file_name", collation: "utf8mb4_unicode_ci"
    t.string "logo_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "primary_color", collation: "utf8mb4_unicode_ci"
    t.string "digest", collation: "utf8mb4_unicode_ci"
    t.boolean "default", default: false
    t.string "secondary_color", collation: "utf8mb4_unicode_ci"
    t.boolean "use_secondary_color", default: false
    t.string "logo_redirect_url", collation: "utf8mb4_unicode_ci"
  end

  create_table "topic_feedbacks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "topic_id"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured", default: false
  end

  create_table "topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "statement", collation: "utf8mb4_unicode_ci"
    t.date "expiration"
    t.integer "user_id"
    t.integer "enterprise_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "accepted_member", default: false
    t.integer "total_weekly_points", default: 0
    t.text "data", collation: "utf8mb4_unicode_ci"
  end

  create_table "user_reward_actions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "reward_action_id", null: false
    t.integer "operation", null: false
    t.integer "points", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "initiative_id"
    t.integer "initiative_comment_id"
    t.integer "group_message_id"
    t.integer "group_message_comment_id"
    t.integer "news_link_id"
    t.integer "news_link_comment_id"
    t.integer "social_link_id"
    t.integer "answer_comment_id"
    t.integer "answer_upvote_id"
    t.integer "answer_id"
    t.integer "poll_response_id"
    t.index ["operation"], name: "index_user_reward_actions_on_operation"
    t.index ["reward_action_id"], name: "index_user_reward_actions_on_reward_action_id"
    t.index ["user_id"], name: "index_user_reward_actions_on_user_id"
  end

  create_table "user_rewards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "reward_id", null: false
    t.integer "points", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reward_id"], name: "index_user_rewards_on_reward_id"
    t.index ["user_id"], name: "index_user_rewards_on_user_id"
  end

  create_table "user_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.boolean "default", default: false
    t.string "role_name"
    t.string "role_type", default: "non_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", null: false
    t.index ["enterprise_id"], name: "index_user_roles_on_enterprise_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "first_name", collation: "utf8mb4_unicode_ci"
    t.string "last_name", collation: "utf8mb4_unicode_ci"
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.string "auth_source", collation: "utf8mb4_unicode_ci"
    t.integer "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", collation: "utf8mb4_unicode_ci"
    t.string "encrypted_password", collation: "utf8mb4_unicode_ci"
    t.string "reset_password_token", collation: "utf8mb4_unicode_ci"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", collation: "utf8mb4_unicode_ci"
    t.string "last_sign_in_ip", collation: "utf8mb4_unicode_ci"
    t.string "invitation_token", collation: "utf8mb4_unicode_ci"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type", collation: "utf8mb4_unicode_ci"
    t.integer "invitations_count", default: 0
    t.string "provider", collation: "utf8mb4_unicode_ci"
    t.string "uid", collation: "utf8mb4_unicode_ci"
    t.text "tokens", collation: "utf8mb4_unicode_ci"
    t.string "firebase_token", collation: "utf8mb4_unicode_ci"
    t.datetime "firebase_token_generated_at"
    t.integer "participation_score_7days", default: 0
    t.string "yammer_token", collation: "utf8mb4_unicode_ci"
    t.string "linkedin_profile_url", collation: "utf8mb4_unicode_ci"
    t.string "avatar_file_name", collation: "utf8mb4_unicode_ci"
    t.string "avatar_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "active", default: true
    t.text "biography", collation: "utf8mb4_unicode_ci"
    t.integer "points", default: 0, null: false
    t.integer "credits", default: 0, null: false
    t.string "time_zone", collation: "utf8mb4_unicode_ci"
    t.integer "total_weekly_points", default: 0
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token", collation: "utf8mb4_unicode_ci"
    t.datetime "locked_at"
    t.boolean "custom_policy_group", default: false, null: false
    t.integer "user_role_id"
    t.boolean "mentee", default: false
    t.boolean "mentor", default: false
    t.text "mentorship_description"
    t.integer "groups_notifications_frequency", default: 2
    t.integer "groups_notifications_date", default: 5
    t.boolean "accepting_mentor_requests", default: true
    t.boolean "accepting_mentee_requests", default: true
    t.datetime "last_group_notification_date"
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_segments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "segment_id"
    t.index ["user_id"], name: "index_users_segments_on_user_id"
  end

  create_table "views", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "news_feed_link_id"
    t.integer "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "folder_id"
    t.integer "resource_id"
  end

  create_table "yammer_field_mappings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "enterprise_id"
    t.string "yammer_field_name", collation: "utf8mb4_unicode_ci"
    t.integer "diverst_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "badges", "enterprises"
  add_foreign_key "budgets", "users", column: "approver_id"
  add_foreign_key "budgets", "users", column: "requester_id"
  add_foreign_key "custom_texts", "enterprises"
  add_foreign_key "likes", "answers"
  add_foreign_key "likes", "enterprises"
  add_foreign_key "likes", "news_feed_links"
  add_foreign_key "likes", "users"
  add_foreign_key "mentoring_session_comments", "mentoring_sessions"
  add_foreign_key "mentoring_session_comments", "users"
  add_foreign_key "mentorship_availabilities", "users"
  add_foreign_key "polls", "initiatives"
  add_foreign_key "reward_actions", "enterprises"
  add_foreign_key "rewards", "enterprises"
  add_foreign_key "rewards", "users", column: "responsible_id"
  add_foreign_key "shared_metrics_dashboards", "metrics_dashboards"
  add_foreign_key "shared_metrics_dashboards", "users"
  add_foreign_key "user_reward_actions", "reward_actions"
  add_foreign_key "user_reward_actions", "users"
  add_foreign_key "user_rewards", "rewards"
  add_foreign_key "user_rewards", "users"
  add_foreign_key "user_roles", "enterprises"
end
