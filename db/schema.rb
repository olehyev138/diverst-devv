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

ActiveRecord::Schema.define(version: 2019_11_05_183507) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "trackable_type", collation: "utf8mb4_unicode_ci"
    t.bigint "trackable_id"
    t.string "owner_type", collation: "utf8mb4_unicode_ci"
    t.bigint "owner_id"
    t.string "key", collation: "utf8mb4_unicode_ci"
    t.text "parameters", collation: "utf8mb4_unicode_ci"
    t.string "recipient_type", collation: "utf8mb4_unicode_ci"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "annual_budgets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.decimal "amount", precision: 10, default: "0"
    t.boolean "closed", default: false
    t.decimal "available_budget", precision: 10, default: "0"
    t.decimal "approved_budget", precision: 10, default: "0"
    t.decimal "expenses", precision: 10, default: "0"
    t.decimal "leftover_money", precision: 10, default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.bigint "enterprise_id"
    t.index ["group_id", "enterprise_id"], name: "index_annual_budgets_on_group_id_and_enterprise_id"
  end

  create_table "answer_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.bigint "author_id"
    t.bigint "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["answer_id"], name: "index_answer_comments_on_answer_id"
    t.index ["author_id"], name: "index_answer_comments_on_author_id"
  end

  create_table "answer_expenses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "answer_id"
    t.bigint "expense_id"
    t.integer "quantity"
    t.index ["answer_id"], name: "index_answer_expenses_on_answer_id"
    t.index ["expense_id"], name: "index_answer_expenses_on_expense_id"
  end

  create_table "answer_upvotes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "author_id"
    t.bigint "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_upvotes_on_answer_id"
    t.index ["author_id"], name: "index_answer_upvotes_on_author_id"
  end

  create_table "answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "author_id"
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
    t.bigint "supporting_document_file_size"
    t.datetime "supporting_document_updated_at"
    t.bigint "contributing_group_id"
    t.index ["author_id"], name: "index_answers_on_author_id"
    t.index ["contributing_group_id"], name: "index_answers_on_contributing_group_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "api_keys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "application_name"
    t.string "key"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_api_keys_on_enterprise_id"
  end

  create_table "badges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id", null: false
    t.integer "points", null: false
    t.string "label", collation: "utf8mb4_unicode_ci"
    t.string "image_file_name", collation: "utf8mb4_unicode_ci"
    t.string "image_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "image_file_size", null: false
    t.datetime "image_updated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_badges_on_enterprise_id"
  end

  create_table "budget_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "budget_id"
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.date "estimated_date"
    t.boolean "is_private", default: false
    t.boolean "is_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "estimated_amount", precision: 8, scale: 2
    t.decimal "available_amount", precision: 8, scale: 2, default: "0.0"
  end

  create_table "budgets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.boolean "is_approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "approver_id"
    t.bigint "requester_id"
    t.bigint "group_id"
    t.text "comments"
    t.string "decline_reason"
    t.bigint "annual_budget_id"
    t.index ["group_id"], name: "index_budgets_on_group_id"
    t.index ["requester_id"], name: "fk_rails_d21f6fbcce"
  end

  create_table "campaign_invitations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "user_id"
    t.integer "response", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_sent", default: false
    t.index ["campaign_id"], name: "index_campaign_invitations_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_invitations_on_user_id"
  end

  create_table "campaigns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.datetime "start"
    t.datetime "end"
    t.integer "nb_invites"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name", collation: "utf8mb4_unicode_ci"
    t.string "image_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "banner_file_name", collation: "utf8mb4_unicode_ci"
    t.string "banner_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "banner_file_size"
    t.datetime "banner_updated_at"
    t.bigint "owner_id"
    t.integer "status", default: 0
    t.index ["enterprise_id"], name: "index_campaigns_on_enterprise_id"
    t.index ["owner_id"], name: "index_campaigns_on_owner_id"
  end

  create_table "campaigns_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "group_id"
    t.index ["campaign_id"], name: "index_campaigns_groups_on_campaign_id"
    t.index ["group_id"], name: "index_campaigns_groups_on_group_id"
  end

  create_table "campaigns_managers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "user_id"
    t.index ["campaign_id"], name: "index_campaigns_managers_on_campaign_id"
    t.index ["user_id"], name: "index_campaigns_managers_on_user_id"
  end

  create_table "campaigns_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "segment_id"
    t.index ["campaign_id"], name: "index_campaigns_segments_on_campaign_id"
    t.index ["segment_id"], name: "index_campaigns_segments_on_segment_id"
  end

  create_table "checklist_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.boolean "is_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "initiative_id"
    t.bigint "checklist_id"
    t.index ["checklist_id"], name: "index_checklist_items_on_checklist_id"
    t.index ["initiative_id"], name: "index_checklist_items_on_initiative_id"
  end

  create_table "checklists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "budget_id"
    t.bigint "initiative_id"
    t.index ["budget_id"], name: "index_checklists_on_budget_id"
    t.index ["initiative_id"], name: "index_checklists_on_initiative_id"
  end

  create_table "ckeditor_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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

  create_table "clockwork_database_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "frequency_quantity", default: 1, null: false
    t.bigint "frequency_period_id", null: false
    t.bigint "enterprise_id", null: false
    t.boolean "disabled", default: false
    t.string "day"
    t.string "at"
    t.string "job_name", null: false
    t.string "method_name", null: false
    t.string "method_args"
    t.string "tz", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_clockwork_database_events_on_enterprise_id"
    t.index ["frequency_period_id"], name: "index_clockwork_database_events_on_frequency_period_id"
  end

  create_table "csvfiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "import_file_file_name"
    t.string "import_file_content_type"
    t.bigint "import_file_file_size"
    t.datetime "import_file_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "group_id"
    t.string "download_file_file_name"
    t.string "download_file_content_type"
    t.bigint "download_file_file_size"
    t.datetime "download_file_updated_at"
    t.string "download_file_name"
  end

  create_table "custom_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "erg", default: "Group"
    t.bigint "enterprise_id"
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

  create_table "devices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "email_variables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enterprise_email_variable_id"
    t.boolean "downcase", default: false
    t.boolean "upcase", default: false
    t.boolean "titleize", default: false
    t.boolean "pluralize", default: false
    t.index ["email_id"], name: "index_email_variables_on_email_id"
    t.index ["enterprise_email_variable_id"], name: "index_email_variables_on_enterprise_email_variable_id"
  end

  create_table "emails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject", collation: "utf8mb4_unicode_ci"
    t.text "content", null: false
    t.string "mailer_name", null: false
    t.string "mailer_method", null: false
    t.string "template"
    t.string "description", null: false
    t.index ["enterprise_id"], name: "index_emails_on_enterprise_id"
  end

  create_table "enterprise_email_variables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "key"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "example"
    t.index ["enterprise_id"], name: "index_enterprise_email_variables_on_enterprise_id"
  end

  create_table "enterprises", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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
    t.bigint "theme_id"
    t.string "cdo_picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "cdo_picture_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "cdo_picture_file_size"
    t.datetime "cdo_picture_updated_at"
    t.text "cdo_message", collation: "utf8mb4_unicode_ci"
    t.boolean "collaborate_module_enabled", default: true, null: false
    t.boolean "scope_module_enabled", default: true, null: false
    t.boolean "plan_module_enabled", default: true, null: false
    t.string "banner_file_name", collation: "utf8mb4_unicode_ci"
    t.string "banner_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "banner_file_size"
    t.datetime "banner_updated_at"
    t.text "home_message"
    t.text "privacy_statement", collation: "utf8mb4_unicode_ci"
    t.boolean "has_enabled_onboarding_email", default: true
    t.string "xml_sso_config_file_name", collation: "utf8mb4_unicode_ci"
    t.string "xml_sso_config_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "xml_sso_config_file_size"
    t.datetime "xml_sso_config_updated_at"
    t.string "iframe_calendar_token", collation: "utf8mb4_unicode_ci"
    t.string "time_zone", collation: "utf8mb4_unicode_ci"
    t.boolean "enable_rewards", default: false
    t.string "company_video_url"
    t.string "onboarding_sponsor_media_file_name"
    t.string "onboarding_sponsor_media_content_type"
    t.bigint "onboarding_sponsor_media_file_size"
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
    t.index ["theme_id"], name: "index_enterprises_on_theme_id"
  end

  create_table "expense_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.string "icon_file_name", collation: "utf8mb4_unicode_ci"
    t.string "icon_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "icon_file_size"
    t.datetime "icon_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_expense_categories_on_enterprise_id"
  end

  create_table "expenses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.integer "price"
    t.boolean "income", default: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["enterprise_id"], name: "index_expenses_on_enterprise_id"
  end

  create_table "field_data", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "field_id"
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_field_data_on_field_id"
    t.index ["user_id"], name: "index_field_data_on_user_id"
  end

  create_table "fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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
    t.bigint "enterprise_id"
    t.bigint "group_id"
    t.bigint "poll_id"
    t.bigint "initiative_id"
    t.index ["enterprise_id"], name: "index_fields_on_enterprise_id"
    t.index ["group_id"], name: "index_fields_on_group_id"
    t.index ["initiative_id"], name: "index_fields_on_initiative_id"
    t.index ["poll_id"], name: "index_fields_on_poll_id"
  end

  create_table "folder_shares", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "folder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enterprise_id"
    t.bigint "group_id"
    t.index ["enterprise_id"], name: "index_folder_shares_on_enterprise_id"
    t.index ["folder_id"], name: "index_folder_shares_on_folder_id"
    t.index ["group_id"], name: "index_folder_shares_on_group_id"
  end

  create_table "folders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "password_protected", default: false
    t.string "password_digest"
    t.bigint "parent_id"
    t.bigint "enterprise_id"
    t.bigint "group_id"
    t.index ["enterprise_id"], name: "index_folders_on_enterprise_id"
    t.index ["group_id"], name: "index_folders_on_group_id"
  end

  create_table "frequency_periods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: "daily", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "graphs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "field_id"
    t.bigint "aggregation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_field", collation: "utf8mb4_unicode_ci"
    t.string "custom_aggregation", collation: "utf8mb4_unicode_ci"
    t.boolean "time_series", default: false
    t.datetime "range_from"
    t.datetime "range_to"
    t.bigint "metrics_dashboard_id"
    t.bigint "poll_id"
    t.index ["aggregation_id"], name: "index_graphs_on_aggregation_id"
    t.index ["field_id"], name: "index_graphs_on_field_id"
    t.index ["metrics_dashboard_id"], name: "index_graphs_on_metrics_dashboard_id"
    t.index ["poll_id"], name: "index_graphs_on_poll_id"
  end

  create_table "group_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_category_type_id"
    t.bigint "enterprise_id"
  end

  create_table "group_category_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enterprise_id"
  end

  create_table "group_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_group_fields_on_field_id"
    t.index ["group_id"], name: "index_group_fields_on_group_id"
  end

  create_table "group_leaders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "user_id"
    t.string "position_name", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true
    t.boolean "pending_member_notifications_enabled", default: false
    t.boolean "pending_comments_notifications_enabled", default: false
    t.boolean "pending_posts_notifications_enabled", default: false
    t.boolean "default_group_contact", default: false
    t.bigint "user_role_id"
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
    t.index ["user_role_id"], name: "index_group_leaders_on_user_role_id"
  end

  create_table "group_message_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.bigint "author_id"
    t.bigint "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["author_id"], name: "index_group_message_comments_on_author_id"
    t.index ["message_id"], name: "index_group_message_comments_on_message_id"
  end

  create_table "group_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.string "subject", collation: "utf8mb4_unicode_ci"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.index ["group_id"], name: "index_group_messages_on_group_id"
    t.index ["owner_id"], name: "index_group_messages_on_owner_id"
  end

  create_table "group_messages_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_message_id"
    t.bigint "segment_id"
    t.index ["group_message_id"], name: "index_group_messages_segments_on_group_message_id"
    t.index ["segment_id"], name: "index_group_messages_segments_on_segment_id"
  end

  create_table "group_updates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.text "comments", collation: "utf8mb4_unicode_ci"
    t.bigint "owner_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_updates_on_group_id"
    t.index ["owner_id"], name: "index_group_updates_on_owner_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_file_name", collation: "utf8mb4_unicode_ci"
    t.string "logo_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean "send_invitations"
    t.integer "participation_score_7days"
    t.boolean "yammer_create_group"
    t.boolean "yammer_group_created"
    t.string "yammer_group_name", collation: "utf8mb4_unicode_ci"
    t.boolean "yammer_sync_users"
    t.string "yammer_group_link"
    t.integer "yammer_id"
    t.bigint "manager_id"
    t.bigint "owner_id"
    t.bigint "lead_manager_id"
    t.string "pending_users", collation: "utf8mb4_unicode_ci"
    t.string "members_visibility", collation: "utf8mb4_unicode_ci"
    t.string "messages_visibility", collation: "utf8mb4_unicode_ci"
    t.decimal "annual_budget", precision: 8, scale: 2
    t.decimal "leftover_money", precision: 8, scale: 2, default: "0.0"
    t.string "banner_file_name", collation: "utf8mb4_unicode_ci"
    t.string "banner_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "banner_file_size"
    t.datetime "banner_updated_at"
    t.string "calendar_color", collation: "utf8mb4_unicode_ci"
    t.integer "total_weekly_points", default: 0
    t.boolean "active", default: true
    t.integer "parent_id"
    t.string "sponsor_media_file_name"
    t.string "sponsor_media_content_type"
    t.integer "sponsor_media_file_size"
    t.datetime "sponsor_media_updated_at"
    t.string "company_video_url"
    t.string "latest_news_visibility"
    t.string "upcoming_events_visibility"
    t.bigint "group_category_id"
    t.bigint "group_category_type_id"
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
    t.string "event_attendance_visibility"
    t.index ["enterprise_id"], name: "index_groups_on_enterprise_id"
    t.index ["lead_manager_id"], name: "index_groups_on_lead_manager_id"
    t.index ["manager_id"], name: "index_groups_on_manager_id"
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "groups_metrics_dashboards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "metrics_dashboard_id"
    t.index ["group_id"], name: "index_groups_metrics_dashboards_on_group_id"
    t.index ["metrics_dashboard_id"], name: "index_groups_metrics_dashboards_on_metrics_dashboard_id"
  end

  create_table "groups_polls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "poll_id"
    t.index ["group_id"], name: "index_groups_polls_on_group_id"
    t.index ["poll_id"], name: "index_groups_polls_on_poll_id"
  end

  create_table "initiative_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "user_id"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "initiative_expenses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "description", collation: "utf8mb4_unicode_ci"
    t.integer "amount"
    t.bigint "owner_id"
    t.bigint "initiative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "annual_budget_id"
    t.index ["initiative_id"], name: "index_initiative_expenses_on_initiative_id"
    t.index ["owner_id"], name: "index_initiative_expenses_on_owner_id"
  end

  create_table "initiative_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "field_id"
    t.index ["field_id"], name: "index_initiative_fields_on_field_id"
    t.index ["initiative_id"], name: "index_initiative_fields_on_initiative_id"
  end

  create_table "initiative_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_initiative_groups_on_group_id"
    t.index ["initiative_id"], name: "index_initiative_groups_on_initiative_id"
  end

  create_table "initiative_invitees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "user_id"
  end

  create_table "initiative_participating_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "group_id"
  end

  create_table "initiative_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "segment_id"
  end

  create_table "initiative_updates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.text "comments", collation: "utf8mb4_unicode_ci"
    t.bigint "owner_id"
    t.bigint "initiative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "report_date"
    t.index ["initiative_id"], name: "index_initiative_updates_on_initiative_id"
    t.index ["owner_id"], name: "index_initiative_updates_on_owner_id"
  end

  create_table "initiative_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "initiative_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attended", default: false
    t.datetime "check_in_time"
    t.index ["initiative_id"], name: "index_initiative_users_on_initiative_id"
    t.index ["user_id"], name: "index_initiative_users_on_user_id"
  end

  create_table "initiatives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.datetime "start"
    t.datetime "end"
    t.decimal "estimated_funding", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "actual_funding"
    t.bigint "owner_id"
    t.bigint "pillar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.integer "max_attendees"
    t.string "picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "picture_content_type", collation: "utf8mb4_unicode_ci"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
    t.bigint "owner_group_id"
    t.string "location", collation: "utf8mb4_unicode_ci"
    t.bigint "budget_item_id"
    t.boolean "finished_expenses", default: false
    t.datetime "archived_at"
    t.bigint "annual_budget_id"
    t.string "qr_code_file_name"
    t.string "qr_code_content_type"
    t.integer "qr_code_file_size"
    t.datetime "qr_code_updated_at"
    t.index ["owner_id"], name: "index_initiatives_on_owner_id"
    t.index ["pillar_id"], name: "index_initiatives_on_pillar_id"
  end

  create_table "invitation_segments_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "segment_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_invitation_segments_groups_on_group_id"
    t.index ["segment_id"], name: "index_invitation_segments_groups_on_segment_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "news_feed_link_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enterprise_id"
    t.bigint "answer_id"
    t.index ["answer_id"], name: "index_likes_on_answer_id"
    t.index ["enterprise_id"], name: "index_likes_on_enterprise_id"
    t.index ["news_feed_link_id"], name: "index_likes_on_news_feed_link_id"
    t.index ["user_id", "answer_id", "enterprise_id"], name: "index_likes_on_user_id_and_answer_id_and_enterprise_id", unique: true
    t.index ["user_id", "news_feed_link_id", "enterprise_id"], name: "index_likes_on_user_id_and_news_feed_link_id_and_enterprise_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "mentoring_interests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_mentoring_interests_on_enterprise_id"
  end

  create_table "mentoring_request_interests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "mentoring_request_id", null: false
    t.bigint "mentoring_interest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_interest_id"], name: "index_mentoring_request_interests_on_mentoring_interest_id"
    t.index ["mentoring_request_id"], name: "index_mentoring_request_interests_on_mentoring_request_id"
  end

  create_table "mentoring_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "status", default: "pending", null: false
    t.text "notes"
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mentoring_type", default: "mentor", null: false
    t.index ["enterprise_id"], name: "index_mentoring_requests_on_enterprise_id"
    t.index ["receiver_id"], name: "index_mentoring_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_mentoring_requests_on_sender_id"
  end

  create_table "mentoring_session_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "mentoring_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_session_id"], name: "index_mentoring_session_comments_on_mentoring_session_id"
    t.index ["user_id"], name: "index_mentoring_session_comments_on_user_id"
  end

  create_table "mentoring_session_topics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "mentoring_interest_id", null: false
    t.bigint "mentoring_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_interest_id"], name: "index_mentoring_session_topics_on_mentoring_interest_id"
    t.index ["mentoring_session_id"], name: "index_mentoring_session_topics_on_mentoring_session_id"
  end

  create_table "mentoring_sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.bigint "creator_id", null: false
    t.datetime "start", null: false
    t.datetime "end", null: false
    t.string "format", null: false
    t.string "link"
    t.text "access_token"
    t.string "video_room_name"
    t.string "status", default: "scheduled", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_mentoring_sessions_on_creator_id"
    t.index ["enterprise_id"], name: "index_mentoring_sessions_on_enterprise_id"
  end

  create_table "mentoring_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_mentoring_types_on_enterprise_id"
  end

  create_table "mentorings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "mentor_id"
    t.bigint "mentee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentee_id"], name: "index_mentorings_on_mentee_id"
    t.index ["mentor_id"], name: "index_mentorings_on_mentor_id"
  end

  create_table "mentorship_availabilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day", default: 1, null: false
    t.time "start", null: false
    t.time "end", null: false
    t.index ["user_id"], name: "index_mentorship_availabilities_on_user_id"
  end

  create_table "mentorship_interests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mentoring_interest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_interest_id"], name: "index_mentorship_interests_on_mentoring_interest_id"
    t.index ["user_id"], name: "index_mentorship_interests_on_user_id"
  end

  create_table "mentorship_ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "rating", null: false
    t.bigint "user_id", null: false
    t.bigint "mentoring_session_id", null: false
    t.boolean "okrs_achieved", default: false
    t.boolean "valuable", default: false
    t.text "comments", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_session_id"], name: "index_mentorship_ratings_on_mentoring_session_id"
    t.index ["user_id"], name: "index_mentorship_ratings_on_user_id"
  end

  create_table "mentorship_sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "role", null: false
    t.bigint "mentoring_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending", null: false
    t.index ["mentoring_session_id"], name: "index_mentorship_sessions_on_mentoring_session_id"
    t.index ["user_id"], name: "index_mentorship_sessions_on_user_id"
  end

  create_table "mentorship_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mentoring_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentoring_type_id"], name: "index_mentorship_types_on_mentoring_type_id"
    t.index ["user_id"], name: "index_mentorship_types_on_user_id"
  end

  create_table "metrics_dashboards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.string "shareable_token"
    t.index ["enterprise_id"], name: "index_metrics_dashboards_on_enterprise_id"
    t.index ["owner_id"], name: "index_metrics_dashboards_on_owner_id"
  end

  create_table "metrics_dashboards_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "metrics_dashboard_id"
    t.bigint "segment_id"
    t.index ["metrics_dashboard_id"], name: "index_metrics_dashboards_segments_on_metrics_dashboard_id"
    t.index ["segment_id"], name: "index_metrics_dashboards_segments_on_segment_id"
  end

  create_table "mobile_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.bigint "field_id"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_mobile_fields_on_enterprise_id"
    t.index ["field_id"], name: "index_mobile_fields_on_field_id"
  end

  create_table "news_feed_link_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "news_feed_link_id"
    t.bigint "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "news_link_segment_id"
    t.bigint "group_messages_segment_id"
    t.bigint "social_link_segment_id"
    t.index ["group_messages_segment_id"], name: "index_news_feed_link_segments_on_group_messages_segment_id"
    t.index ["news_feed_link_id"], name: "news_feed_link_index"
    t.index ["news_link_segment_id"], name: "index_news_feed_link_segments_on_news_link_segment_id"
    t.index ["segment_id"], name: "segment_index"
    t.index ["social_link_segment_id"], name: "index_news_feed_link_segments_on_social_link_segment_id"
  end

  create_table "news_feed_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "news_feed_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "news_link_id"
    t.bigint "group_message_id"
    t.bigint "social_link_id"
    t.boolean "is_pinned", default: false
    t.datetime "archived_at"
    t.index ["group_message_id"], name: "index_news_feed_links_on_group_message_id"
    t.index ["news_feed_id"], name: "index_news_feed_links_on_news_feed_id"
    t.index ["news_link_id"], name: "index_news_feed_links_on_news_link_id"
    t.index ["social_link_id"], name: "index_news_feed_links_on_social_link_id"
  end

  create_table "news_feeds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_news_feeds_on_group_id"
  end

  create_table "news_link_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.bigint "author_id"
    t.bigint "news_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["author_id"], name: "index_news_link_comments_on_author_id"
    t.index ["news_link_id"], name: "index_news_link_comments_on_news_link_id"
  end

  create_table "news_link_photos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
    t.bigint "news_link_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_link_id"], name: "index_news_link_photos_on_news_link_id"
  end

  create_table "news_link_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "news_link_id"
    t.bigint "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_link_id"], name: "index_news_link_segments_on_news_link_id"
    t.index ["segment_id"], name: "index_news_link_segments_on_segment_id"
  end

  create_table "news_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description"
    t.string "url", collation: "utf8mb4_unicode_ci"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "picture_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "picture_file_size"
    t.datetime "picture_updated_at"
    t.bigint "author_id"
    t.index ["group_id"], name: "index_news_links_on_group_id"
  end

  create_table "outcomes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_outcomes_on_group_id"
  end

  create_table "pillars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.string "value_proposition", collation: "utf8mb4_unicode_ci"
    t.bigint "outcome_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outcome_id"], name: "index_pillars_on_outcome_id"
  end

  create_table "policy_group_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "default", default: false
    t.bigint "user_role_id"
    t.bigint "enterprise_id"
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
    t.index ["enterprise_id"], name: "index_policy_group_templates_on_enterprise_id"
    t.index ["user_role_id"], name: "index_policy_group_templates_on_user_role_id"
  end

  create_table "policy_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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
    t.bigint "user_id"
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

  create_table "poll_responses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "poll_id"
    t.bigint "user_id"
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "anonymous", default: false
    t.index ["poll_id"], name: "index_poll_responses_on_poll_id"
    t.index ["user_id"], name: "index_poll_responses_on_user_id"
  end

  create_table "polls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.time "start"
    t.time "end"
    t.integer "nb_invitations"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.integer "status", default: 0, null: false
    t.boolean "email_sent", default: false, null: false
    t.bigint "initiative_id"
    t.index ["enterprise_id"], name: "index_polls_on_enterprise_id"
    t.index ["initiative_id"], name: "index_polls_on_initiative_id"
    t.index ["owner_id"], name: "index_polls_on_owner_id"
  end

  create_table "polls_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "poll_id"
    t.bigint "segment_id"
    t.index ["poll_id"], name: "index_polls_segments_on_poll_id"
    t.index ["segment_id"], name: "index_polls_segments_on_segment_id"
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.bigint "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "solved_at"
    t.text "conclusion", collation: "utf8mb4_unicode_ci"
    t.index ["campaign_id"], name: "index_questions_on_campaign_id"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name", collation: "utf8mb4_unicode_ci"
    t.string "file_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
    t.bigint "owner_id"
    t.string "resource_type"
    t.string "url", limit: 255
    t.bigint "mentoring_session_id"
    t.bigint "enterprise_id"
    t.bigint "folder_id"
    t.bigint "group_id"
    t.bigint "initiative_id"
    t.datetime "archived_at"
    t.index ["enterprise_id"], name: "index_resources_on_enterprise_id"
    t.index ["folder_id"], name: "index_resources_on_folder_id"
    t.index ["group_id"], name: "index_resources_on_group_id"
    t.index ["initiative_id"], name: "index_resources_on_initiative_id"
    t.index ["mentoring_session_id"], name: "index_resources_on_mentoring_session_id"
    t.index ["owner_id"], name: "index_resources_on_owner_id"
  end

  create_table "reward_actions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "label", collation: "utf8mb4_unicode_ci"
    t.integer "points"
    t.string "key", collation: "utf8mb4_unicode_ci"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_reward_actions_on_enterprise_id"
  end

  create_table "rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "points", null: false
    t.string "label", collation: "utf8mb4_unicode_ci"
    t.string "picture_file_name", collation: "utf8mb4_unicode_ci"
    t.string "picture_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "picture_file_size"
    t.datetime "picture_updated_at"
    t.text "description", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enterprise_id"
    t.bigint "responsible_id"
    t.index ["enterprise_id"], name: "fk_rails_63c825065e"
    t.index ["responsible_id"], name: "fk_rails_b30ff5b6ea"
  end

  create_table "samples", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_samples_on_user_id"
  end

  create_table "segment_field_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "segment_id"
    t.bigint "field_id"
    t.integer "operator"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_segment_field_rules_on_field_id"
    t.index ["segment_id"], name: "index_segment_field_rules_on_segment_id"
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

  create_table "segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.string "active_users_filter", collation: "utf8mb4_unicode_ci"
    t.integer "limit"
    t.integer "job_status", default: 0, null: false
    t.bigint "parent_id"
    t.index ["enterprise_id"], name: "index_segments_on_enterprise_id"
    t.index ["owner_id"], name: "index_segments_on_owner_id"
    t.index ["parent_id"], name: "index_segments_on_parent_id"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "token"
    t.datetime "expires_at"
    t.string "device_type"
    t.string "device_name"
    t.string "device_version"
    t.string "operating_system"
    t.string "status"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shared_metrics_dashboards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "metrics_dashboard_id"
    t.index ["metrics_dashboard_id"], name: "index_shared_metrics_dashboards_on_metrics_dashboard_id"
    t.index ["user_id"], name: "index_shared_metrics_dashboards_on_user_id"
  end

  create_table "shared_news_feed_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "news_feed_link_id", null: false
    t.bigint "news_feed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_feed_id"], name: "index_shared_news_feed_links_on_news_feed_id"
    t.index ["news_feed_link_id"], name: "index_shared_news_feed_links_on_news_feed_link_id"
  end

  create_table "social_link_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "social_link_id"
    t.bigint "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segment_id"], name: "index_social_link_segments_on_segment_id"
    t.index ["social_link_id"], name: "index_social_link_segments_on_social_link_id"
  end

  create_table "social_network_posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "author_id"
    t.text "embed_code", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", collation: "utf8mb4_unicode_ci"
    t.bigint "group_id"
  end

  create_table "sponsors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "sponsor_name"
    t.string "sponsor_title"
    t.text "sponsor_message"
    t.boolean "disable_sponsor_message"
    t.string "sponsorable_type"
    t.bigint "sponsorable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sponsor_media_file_name"
    t.string "sponsor_media_content_type"
    t.bigint "sponsor_media_file_size"
    t.datetime "sponsor_media_updated_at"
    t.index ["sponsorable_type", "sponsorable_id"], name: "index_sponsors_on_sponsorable_type_and_sponsorable_id"
  end

  create_table "survey_managers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "user_id"
    t.index ["survey_id"], name: "index_survey_managers_on_survey_id"
    t.index ["user_id"], name: "index_survey_managers_on_user_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "resource_id"
    t.index ["resource_id"], name: "index_tags_on_resource_id"
  end

  create_table "themes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "logo_file_name", collation: "utf8mb4_unicode_ci"
    t.string "logo_content_type", collation: "utf8mb4_unicode_ci"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "primary_color", collation: "utf8mb4_unicode_ci"
    t.string "digest", collation: "utf8mb4_unicode_ci"
    t.boolean "default", default: false
    t.string "secondary_color", collation: "utf8mb4_unicode_ci"
    t.boolean "use_secondary_color", default: false
    t.string "logo_redirect_url", collation: "utf8mb4_unicode_ci"
  end

  create_table "topic_feedbacks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "topic_id"
    t.text "content", collation: "utf8mb4_unicode_ci"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured", default: false
    t.index ["topic_id"], name: "index_topic_feedbacks_on_topic_id"
    t.index ["user_id"], name: "index_topic_feedbacks_on_user_id"
  end

  create_table "topics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "statement", collation: "utf8mb4_unicode_ci"
    t.date "expiration"
    t.bigint "user_id"
    t.bigint "enterprise_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_topics_on_category_id"
    t.index ["enterprise_id"], name: "index_topics_on_enterprise_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "twitter_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "group_id"
    t.string "name", null: false
    t.string "account", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_twitter_accounts_on_group_id"
  end

  create_table "user_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted_member", default: false
    t.integer "total_weekly_points", default: 0
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "user_reward_actions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "reward_action_id", null: false
    t.integer "operation", null: false
    t.integer "points", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "initiative_id"
    t.bigint "initiative_comment_id"
    t.bigint "group_message_id"
    t.bigint "group_message_comment_id"
    t.bigint "news_link_id"
    t.bigint "news_link_comment_id"
    t.bigint "social_link_id"
    t.bigint "answer_comment_id"
    t.bigint "answer_upvote_id"
    t.bigint "answer_id"
    t.bigint "poll_response_id"
    t.index ["answer_comment_id"], name: "index_user_reward_actions_on_answer_comment_id"
    t.index ["answer_id"], name: "index_user_reward_actions_on_answer_id"
    t.index ["answer_upvote_id"], name: "index_user_reward_actions_on_answer_upvote_id"
    t.index ["group_message_comment_id"], name: "index_user_reward_actions_on_group_message_comment_id"
    t.index ["group_message_id"], name: "index_user_reward_actions_on_group_message_id"
    t.index ["initiative_comment_id"], name: "index_user_reward_actions_on_initiative_comment_id"
    t.index ["initiative_id"], name: "index_user_reward_actions_on_initiative_id"
    t.index ["news_link_comment_id"], name: "index_user_reward_actions_on_news_link_comment_id"
    t.index ["news_link_id"], name: "index_user_reward_actions_on_news_link_id"
    t.index ["operation"], name: "index_user_reward_actions_on_operation"
    t.index ["poll_response_id"], name: "index_user_reward_actions_on_poll_response_id"
    t.index ["reward_action_id"], name: "index_user_reward_actions_on_reward_action_id"
    t.index ["social_link_id"], name: "index_user_reward_actions_on_social_link_id"
    t.index ["user_id"], name: "index_user_reward_actions_on_user_id"
  end

  create_table "user_rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "reward_id", null: false
    t.integer "points", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_user_rewards_on_reward_id"
    t.index ["user_id"], name: "index_user_rewards_on_user_id"
  end

  create_table "user_roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.boolean "default", default: false
    t.string "role_name"
    t.string "role_type", default: "non_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", null: false
    t.index ["enterprise_id"], name: "index_user_roles_on_enterprise_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "first_name", collation: "utf8mb4_unicode_ci"
    t.string "last_name", collation: "utf8mb4_unicode_ci"
    t.text "data", collation: "utf8mb4_unicode_ci"
    t.string "auth_source", collation: "utf8mb4_unicode_ci"
    t.bigint "enterprise_id"
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
    t.string "invited_by_type", collation: "utf8mb4_unicode_ci"
    t.bigint "invited_by_id"
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
    t.bigint "avatar_file_size"
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
    t.bigint "user_role_id"
    t.boolean "mentee", default: false
    t.boolean "mentor", default: false
    t.text "mentorship_description"
    t.integer "groups_notifications_frequency", default: 2
    t.integer "groups_notifications_date", default: 5
    t.boolean "accepting_mentor_requests", default: true
    t.boolean "accepting_mentee_requests", default: true
    t.datetime "last_group_notification_date"
    t.string "password_digest"
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["enterprise_id"], name: "index_users_on_enterprise_id"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["user_role_id"], name: "index_users_on_user_role_id"
  end

  create_table "users_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "segment_id"
    t.index ["segment_id"], name: "index_users_segments_on_segment_id"
    t.index ["user_id"], name: "index_users_segments_on_user_id"
  end

  create_table "views", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "news_feed_link_id"
    t.bigint "enterprise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.bigint "folder_id"
    t.bigint "resource_id"
  end

  create_table "yammer_field_mappings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "enterprise_id"
    t.string "yammer_field_name", collation: "utf8mb4_unicode_ci"
    t.bigint "diverst_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diverst_field_id"], name: "index_yammer_field_mappings_on_diverst_field_id"
    t.index ["enterprise_id"], name: "index_yammer_field_mappings_on_enterprise_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "badges", "enterprises"
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
