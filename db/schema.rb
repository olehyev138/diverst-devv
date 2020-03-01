# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20200227151322) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 191
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 191
    t.string   "key",            limit: 191
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 191
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "annual_budgets", force: :cascade do |t|
    t.integer  "group_id",         limit: 4
    t.integer  "enterprise_id",    limit: 4
    t.decimal  "amount",                     precision: 10, default: 0
    t.boolean  "closed",                                    default: false
    t.decimal  "available_budget",           precision: 10, default: 0
    t.decimal  "approved_budget",            precision: 10, default: 0
    t.decimal  "expenses",                   precision: 10, default: 0
    t.decimal  "leftover_money",             precision: 10, default: 0
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "annual_budgets", ["enterprise_id"], name: "index_annual_budgets_on_enterprise_id", using: :btree
  add_index "annual_budgets", ["group_id"], name: "index_annual_budgets_on_group_id", using: :btree

  create_table "answer_comments", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.integer  "answer_id",  limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "approved",                 default: false
  end

  create_table "answer_expenses", force: :cascade do |t|
    t.integer "answer_id",  limit: 4
    t.integer "expense_id", limit: 4
    t.integer "quantity",   limit: 4
  end

  create_table "answer_upvotes", force: :cascade do |t|
    t.integer  "author_id",  limit: 4
    t.integer  "answer_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id",                      limit: 4
    t.integer  "author_id",                        limit: 4
    t.text     "content",                          limit: 65535
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.boolean  "chosen"
    t.integer  "upvote_count",                     limit: 4,     default: 0
    t.text     "outcome",                          limit: 65535
    t.integer  "value",                            limit: 4
    t.integer  "benefit_type",                     limit: 4
    t.string   "supporting_document_file_name",    limit: 191
    t.string   "supporting_document_content_type", limit: 191
    t.integer  "supporting_document_file_size",    limit: 4
    t.datetime "supporting_document_updated_at"
    t.integer  "contributing_group_id",            limit: 4
    t.integer  "likes_count",                      limit: 4
  end

  add_index "answers", ["contributing_group_id"], name: "index_answers_on_contributing_group_id", using: :btree

  create_table "badges", force: :cascade do |t|
    t.integer  "enterprise_id",      limit: 4,   null: false
    t.integer  "points",             limit: 4,   null: false
    t.string   "label",              limit: 191
    t.string   "image_file_name",    limit: 191
    t.string   "image_content_type", limit: 191
    t.integer  "image_file_size",    limit: 4,   null: false
    t.datetime "image_updated_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges", ["enterprise_id"], name: "index_badges_on_enterprise_id", using: :btree

  create_table "budget_items", force: :cascade do |t|
    t.integer  "budget_id",        limit: 4
    t.string   "title",            limit: 191
    t.date     "estimated_date"
    t.boolean  "is_private",                                           default: false
    t.boolean  "is_done",                                              default: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.decimal  "estimated_amount",             precision: 8, scale: 2
    t.decimal  "available_amount",             precision: 8, scale: 2, default: 0.0
  end

  create_table "budgets", force: :cascade do |t|
    t.text     "description",        limit: 65535
    t.boolean  "is_approved"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "approver_id",        limit: 4
    t.integer  "requester_id",       limit: 4
    t.integer  "group_id",           limit: 4
    t.text     "comments",           limit: 65535
    t.string   "decline_reason",     limit: 191
    t.integer  "annual_budget_id",   limit: 4
    t.integer  "budget_items_count", limit: 4
  end

  add_index "budgets", ["approver_id"], name: "fk_rails_a057b1443a", using: :btree
  add_index "budgets", ["requester_id"], name: "fk_rails_d21f6fbcce", using: :btree

  create_table "campaign_invitations", force: :cascade do |t|
    t.integer  "campaign_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.integer  "response",    limit: 4, default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "email_sent",            default: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "title",               limit: 191
    t.text     "description",         limit: 65535
    t.datetime "start"
    t.datetime "end"
    t.integer  "nb_invites",          limit: 4
    t.integer  "enterprise_id",       limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "image_file_name",     limit: 191
    t.string   "image_content_type",  limit: 191
    t.integer  "image_file_size",     limit: 4
    t.datetime "image_updated_at"
    t.string   "banner_file_name",    limit: 191
    t.string   "banner_content_type", limit: 191
    t.integer  "banner_file_size",    limit: 4
    t.datetime "banner_updated_at"
    t.integer  "owner_id",            limit: 4
    t.integer  "status",              limit: 4,     default: 0
    t.integer  "questions_count",     limit: 4
  end

  create_table "campaigns_groups", force: :cascade do |t|
    t.integer "campaign_id", limit: 4
    t.integer "group_id",    limit: 4
  end

  create_table "campaigns_managers", force: :cascade do |t|
    t.integer "campaign_id", limit: 4
    t.integer "user_id",     limit: 4
  end

  create_table "campaigns_segments", force: :cascade do |t|
    t.integer "campaign_id", limit: 4
    t.integer "segment_id",  limit: 4
  end

  create_table "checklist_items", force: :cascade do |t|
    t.string   "title",         limit: 191
    t.boolean  "is_done",                   default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "initiative_id", limit: 4
    t.integer  "checklist_id",  limit: 4
  end

  create_table "checklists", force: :cascade do |t|
    t.string   "title",         limit: 191
    t.integer  "author_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "budget_id",     limit: 4
    t.integer  "initiative_id", limit: 4
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 191
    t.string   "data_content_type", limit: 191
    t.integer  "data_file_size",    limit: 4
    t.string   "data_fingerprint",  limit: 191
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type", using: :btree

  create_table "clockwork_database_events", force: :cascade do |t|
    t.string   "name",                limit: 191,                 null: false
    t.integer  "frequency_quantity",  limit: 4,   default: 1,     null: false
    t.integer  "frequency_period_id", limit: 4,                   null: false
    t.integer  "enterprise_id",       limit: 4,                   null: false
    t.boolean  "disabled",                        default: false
    t.string   "day",                 limit: 191
    t.string   "at",                  limit: 191
    t.string   "job_name",            limit: 191,                 null: false
    t.string   "method_name",         limit: 191,                 null: false
    t.string   "method_args",         limit: 191
    t.string   "tz",                  limit: 191,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clockwork_database_events", ["frequency_period_id"], name: "index_clockwork_database_events_on_frequency_period_id", using: :btree

  create_table "csvfiles", force: :cascade do |t|
    t.string   "import_file_file_name",      limit: 191
    t.string   "import_file_content_type",   limit: 191
    t.integer  "import_file_file_size",      limit: 4
    t.datetime "import_file_updated_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id",                    limit: 4,   null: false
    t.integer  "group_id",                   limit: 4
    t.string   "download_file_file_name",    limit: 191
    t.string   "download_file_content_type", limit: 191
    t.integer  "download_file_file_size",    limit: 4
    t.datetime "download_file_updated_at"
    t.string   "download_file_name",         limit: 191
  end

  create_table "custom_texts", force: :cascade do |t|
    t.string  "erg",               limit: 191, default: "Group"
    t.integer "enterprise_id",     limit: 4
    t.string  "program",           limit: 191, default: "Goal"
    t.string  "structure",         limit: 191, default: "Structure"
    t.string  "outcome",           limit: 191, default: "Focus Areas"
    t.string  "badge",             limit: 191, default: "Badge"
    t.string  "segment",           limit: 191, default: "Segment"
    t.string  "dci_full_title",    limit: 191, default: "Engagement"
    t.string  "dci_abbreviation",  limit: 191, default: "Engagement"
    t.string  "member_preference", limit: 191, default: "Member Survey"
    t.string  "parent",            limit: 191, default: "Parent"
    t.string  "sub_erg",           limit: 191, default: "Sub-Group"
    t.string  "privacy_statement", limit: 191, default: "Privacy Statement"
  end

  add_index "custom_texts", ["enterprise_id"], name: "index_custom_texts_on_enterprise_id", using: :btree

  create_table "email_variables", force: :cascade do |t|
    t.integer  "email_id",                     limit: 4
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "enterprise_email_variable_id", limit: 4
    t.boolean  "downcase",                               default: false
    t.boolean  "upcase",                                 default: false
    t.boolean  "titleize",                               default: false
    t.boolean  "pluralize",                              default: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "name",          limit: 191
    t.integer  "enterprise_id", limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "subject",       limit: 191
    t.text     "content",       limit: 65535,                 null: false
    t.string   "mailer_name",   limit: 191,                   null: false
    t.string   "mailer_method", limit: 191,                   null: false
    t.string   "template",      limit: 191
    t.string   "description",   limit: 191,                   null: false
    t.boolean  "custom",                      default: false
  end

  create_table "enterprise_email_variables", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.string   "key",           limit: 191
    t.string   "description",   limit: 191
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "example",       limit: 65535
  end

  create_table "enterprises", force: :cascade do |t|
    t.string   "name",                                  limit: 191
    t.string   "sp_entity_id",                          limit: 191
    t.string   "idp_entity_id",                         limit: 191
    t.string   "idp_sso_target_url",                    limit: 191
    t.string   "idp_slo_target_url",                    limit: 191
    t.text     "idp_cert",                              limit: 65535
    t.string   "saml_first_name_mapping",               limit: 191
    t.string   "saml_last_name_mapping",                limit: 191
    t.boolean  "has_enabled_saml"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.string   "yammer_token",                          limit: 191
    t.boolean  "yammer_import",                                       default: false
    t.boolean  "yammer_group_sync",                                   default: false
    t.integer  "theme_id",                              limit: 4
    t.string   "cdo_picture_file_name",                 limit: 191
    t.string   "cdo_picture_content_type",              limit: 191
    t.integer  "cdo_picture_file_size",                 limit: 4
    t.datetime "cdo_picture_updated_at"
    t.text     "cdo_message",                           limit: 65535
    t.boolean  "collaborate_module_enabled",                          default: true,  null: false
    t.boolean  "scope_module_enabled",                                default: true,  null: false
    t.boolean  "plan_module_enabled",                                 default: true,  null: false
    t.string   "banner_file_name",                      limit: 191
    t.string   "banner_content_type",                   limit: 191
    t.integer  "banner_file_size",                      limit: 4
    t.datetime "banner_updated_at"
    t.text     "home_message",                          limit: 65535
    t.text     "privacy_statement",                     limit: 65535
    t.boolean  "has_enabled_onboarding_email",                        default: true
    t.string   "xml_sso_config_file_name",              limit: 191
    t.string   "xml_sso_config_content_type",           limit: 191
    t.integer  "xml_sso_config_file_size",              limit: 4
    t.datetime "xml_sso_config_updated_at"
    t.string   "iframe_calendar_token",                 limit: 191
    t.string   "time_zone",                             limit: 191
    t.boolean  "enable_rewards",                                      default: false
    t.string   "company_video_url",                     limit: 191
    t.string   "onboarding_sponsor_media_file_name",    limit: 191
    t.string   "onboarding_sponsor_media_content_type", limit: 191
    t.integer  "onboarding_sponsor_media_file_size",    limit: 4
    t.datetime "onboarding_sponsor_media_updated_at"
    t.boolean  "enable_pending_comments",                             default: false
    t.boolean  "mentorship_module_enabled",                           default: false
    t.boolean  "disable_likes",                                       default: false
    t.string   "default_from_email_address",            limit: 191
    t.string   "default_from_email_display_name",       limit: 191
    t.boolean  "enable_social_media",                                 default: false
    t.boolean  "redirect_all_emails",                                 default: false
    t.string   "redirect_email_contact",                limit: 191
    t.boolean  "disable_emails",                                      default: false
    t.integer  "expiry_age_for_resources",              limit: 4,     default: 0
    t.string   "unit_of_expiry_age",                    limit: 191
    t.boolean  "auto_archive",                                        default: false
    t.string   "sp_mode",                               limit: 191
    t.string   "sp_host",                               limit: 191
    t.string   "sp_site",                               limit: 191
    t.string   "sp_username",                           limit: 191
    t.string   "sp_password",                           limit: 191
    t.integer  "share_point_files_id",                  limit: 4
    t.integer  "share_point_pages_id",                  limit: 4
    t.integer  "share_point_lists_id",                  limit: 4
    t.string   "sp_import_lists",                       limit: 191,   default: "No"
    t.string   "sp_import_files",                       limit: 191,   default: "No"
    t.string   "sp_import_news",                        limit: 191,   default: "No"
    t.boolean  "sp_group_integration",                                default: false
    t.boolean  "sp_group_settings_same",                              default: true
    t.string   "sp_import_pages",                       limit: 191,   default: "No"
    t.boolean  "share_point_active",                                  default: false
    t.integer  "groups_count",                          limit: 4
    t.integer  "segments_count",                        limit: 4
    t.integer  "polls_count",                           limit: 4
    t.integer  "users_count",                           limit: 4
    t.boolean  "slack_enabled",                                       default: false
    t.boolean  "enable_outlook",                                      default: false
  end

  add_index "enterprises", ["share_point_files_id"], name: "fk_rails_6315f961bd", using: :btree
  add_index "enterprises", ["share_point_lists_id"], name: "fk_rails_9079d32818", using: :btree
  add_index "enterprises", ["share_point_pages_id"], name: "fk_rails_a7e31215f7", using: :btree

  create_table "expense_categories", force: :cascade do |t|
    t.integer  "enterprise_id",     limit: 4
    t.string   "name",              limit: 191
    t.string   "icon_file_name",    limit: 191
    t.string   "icon_content_type", limit: 191
    t.integer  "icon_file_size",    limit: 4
    t.datetime "icon_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "enterprise_id", limit: 4
    t.string  "name",          limit: 191
    t.integer "price",         limit: 4
    t.boolean "income",                    default: false
    t.integer "category_id",   limit: 4
  end

  create_table "fields", force: :cascade do |t|
    t.string   "type",               limit: 191
    t.string   "title",              limit: 191
    t.integer  "gamification_value", limit: 4,     default: 1
    t.boolean  "show_on_vcard"
    t.string   "saml_attribute",     limit: 191
    t.text     "options_text",       limit: 65535
    t.integer  "min",                limit: 4
    t.integer  "max",                limit: 4
    t.boolean  "match_exclude"
    t.boolean  "match_polarity"
    t.float    "match_weight",       limit: 24
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "alternative_layout",               default: false
    t.boolean  "private",                          default: false
    t.boolean  "elasticsearch_only",               default: false
    t.boolean  "required",                         default: false
    t.string   "field_type",         limit: 191
    t.integer  "enterprise_id",      limit: 4
    t.integer  "group_id",           limit: 4
    t.integer  "poll_id",            limit: 4
    t.integer  "initiative_id",      limit: 4
    t.boolean  "add_to_member_list",               default: false
  end

  create_table "folder_shares", force: :cascade do |t|
    t.integer  "folder_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "enterprise_id", limit: 4
    t.integer  "group_id",      limit: 4
  end

  create_table "folders", force: :cascade do |t|
    t.string   "name",               limit: 191
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "password_protected",             default: false
    t.string   "password_digest",    limit: 191
    t.integer  "parent_id",          limit: 4
    t.integer  "enterprise_id",      limit: 4
    t.integer  "group_id",           limit: 4
    t.integer  "views_count",        limit: 4
  end

  create_table "frequency_periods", force: :cascade do |t|
    t.string   "name",       limit: 191, default: "daily", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphs", force: :cascade do |t|
    t.integer  "field_id",             limit: 4
    t.integer  "aggregation_id",       limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "custom_field",         limit: 191
    t.string   "custom_aggregation",   limit: 191
    t.boolean  "time_series",                      default: false
    t.datetime "range_from"
    t.datetime "range_to"
    t.integer  "metrics_dashboard_id", limit: 4
    t.integer  "poll_id",              limit: 4
  end

  create_table "group_categories", force: :cascade do |t|
    t.string   "name",                   limit: 191
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "group_category_type_id", limit: 4
    t.integer  "enterprise_id",          limit: 4
  end

  create_table "group_category_types", force: :cascade do |t|
    t.string   "name",          limit: 191
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "enterprise_id", limit: 4
  end

  create_table "group_fields", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.integer  "field_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "group_leaders", force: :cascade do |t|
    t.integer  "group_id",                               limit: 4
    t.integer  "user_id",                                limit: 4
    t.string   "position_name",                          limit: 191
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.boolean  "visible",                                            default: true
    t.boolean  "pending_member_notifications_enabled",               default: false
    t.boolean  "pending_comments_notifications_enabled",             default: false
    t.boolean  "pending_posts_notifications_enabled",                default: false
    t.boolean  "default_group_contact",                              default: false
    t.integer  "user_role_id",                           limit: 4
    t.boolean  "groups_budgets_index",                               default: false, null: false
    t.boolean  "initiatives_manage",                                 default: false, null: false
    t.boolean  "groups_manage",                                      default: false, null: false
    t.boolean  "initiatives_create",                                 default: false
    t.boolean  "groups_budgets_request",                             default: false
    t.boolean  "group_messages_manage",                              default: false
    t.boolean  "group_messages_index",                               default: false
    t.boolean  "group_messages_create",                              default: false
    t.boolean  "news_links_index",                                   default: false
    t.boolean  "news_links_create",                                  default: false
    t.boolean  "news_links_manage",                                  default: false
    t.boolean  "social_links_index",                                 default: false
    t.boolean  "social_links_create",                                default: false
    t.boolean  "social_links_manage",                                default: false
    t.boolean  "group_leader_index",                                 default: false
    t.boolean  "group_leader_manage",                                default: false
    t.boolean  "groups_members_index",                               default: false
    t.boolean  "groups_members_manage",                              default: false
    t.boolean  "groups_insights_manage",                             default: false
    t.boolean  "groups_layouts_manage",                              default: false
    t.boolean  "group_settings_manage",                              default: false
    t.boolean  "group_resources_index",                              default: false
    t.boolean  "group_resources_create",                             default: false
    t.boolean  "group_resources_manage",                             default: false
    t.boolean  "group_posts_index",                                  default: false
    t.boolean  "budget_approval",                                    default: false
    t.boolean  "groups_budgets_manage",                              default: false
    t.boolean  "manage_posts",                                       default: false
    t.boolean  "initiatives_index",                                  default: false
    t.integer  "position",                               limit: 4
  end

  create_table "group_message_comments", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.integer  "message_id", limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "approved",                 default: false
  end

  create_table "group_messages", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.string   "subject",    limit: 191
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "owner_id",   limit: 4
  end

  create_table "group_messages_segments", force: :cascade do |t|
    t.integer "group_message_id", limit: 4
    t.integer "segment_id",       limit: 4
  end

  create_table "group_updates", force: :cascade do |t|
    t.text     "data",       limit: 65535
    t.text     "comments",   limit: 65535
    t.integer  "owner_id",   limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "enterprise_id",               limit: 4
    t.string   "name",                        limit: 191
    t.text     "description",                 limit: 65535
    t.datetime "created_at",                                                                        null: false
    t.datetime "updated_at",                                                                        null: false
    t.string   "logo_file_name",              limit: 191
    t.string   "logo_content_type",           limit: 191
    t.integer  "logo_file_size",              limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "send_invitations"
    t.integer  "participation_score_7days",   limit: 4
    t.boolean  "yammer_create_group"
    t.boolean  "yammer_group_created"
    t.string   "yammer_group_name",           limit: 191
    t.boolean  "yammer_sync_users"
    t.string   "yammer_group_link",           limit: 191
    t.integer  "yammer_id",                   limit: 4
    t.integer  "manager_id",                  limit: 4
    t.integer  "owner_id",                    limit: 4
    t.integer  "lead_manager_id",             limit: 4
    t.string   "pending_users",               limit: 191
    t.string   "members_visibility",          limit: 191
    t.string   "messages_visibility",         limit: 191
    t.decimal  "annual_budget",                             precision: 8, scale: 2
    t.decimal  "leftover_money",                            precision: 8, scale: 2, default: 0.0
    t.string   "banner_file_name",            limit: 191
    t.string   "banner_content_type",         limit: 191
    t.integer  "banner_file_size",            limit: 4
    t.datetime "banner_updated_at"
    t.string   "calendar_color",              limit: 191
    t.integer  "total_weekly_points",         limit: 4,                             default: 0
    t.boolean  "active",                                                            default: true
    t.integer  "parent_id",                   limit: 4
    t.string   "sponsor_image_file_name",     limit: 191
    t.string   "sponsor_image_content_type",  limit: 191
    t.integer  "sponsor_image_file_size",     limit: 4
    t.datetime "sponsor_image_updated_at"
    t.string   "company_video_url",           limit: 191
    t.string   "latest_news_visibility",      limit: 191
    t.string   "upcoming_events_visibility",  limit: 191
    t.integer  "group_category_id",           limit: 4
    t.integer  "group_category_type_id",      limit: 4
    t.boolean  "private",                                                           default: false
    t.text     "short_description",           limit: 65535
    t.string   "layout",                      limit: 191
    t.text     "home_message",                limit: 65535
    t.boolean  "default_mentor_group",                                              default: false
    t.integer  "position",                    limit: 4
    t.integer  "expiry_age_for_news",         limit: 4,                             default: 0
    t.integer  "expiry_age_for_resources",    limit: 4,                             default: 0
    t.integer  "expiry_age_for_events",       limit: 4,                             default: 0
    t.string   "unit_of_expiry_age",          limit: 191
    t.boolean  "auto_archive",                                                      default: false
    t.string   "event_attendance_visibility", limit: 191
    t.string   "sp_mode",                     limit: 191
    t.string   "sp_host",                     limit: 191
    t.string   "sp_site",                     limit: 191
    t.string   "sp_username",                 limit: 191
    t.string   "sp_password",                 limit: 191
    t.integer  "share_point_files_id",        limit: 4
    t.integer  "share_point_pages_id",        limit: 4
    t.integer  "share_point_lists_id",        limit: 4
    t.string   "sp_import_lists",             limit: 191,                           default: "No"
    t.string   "sp_import_files",             limit: 191,                           default: "No"
    t.string   "sp_import_news",              limit: 191,                           default: "No"
    t.string   "sp_import_pages",             limit: 191,                           default: "No"
    t.integer  "views_count",                 limit: 4
    t.string   "slack_webhook",               limit: 191
    t.text     "slack_auth_data",             limit: 65535
  end

  add_index "groups", ["share_point_files_id"], name: "index_groups_on_share_point_files_id", using: :btree
  add_index "groups", ["share_point_lists_id"], name: "index_groups_on_share_point_lists_id", using: :btree
  add_index "groups", ["share_point_pages_id"], name: "index_groups_on_share_point_pages_id", using: :btree

  create_table "groups_metrics_dashboards", force: :cascade do |t|
    t.integer "group_id",             limit: 4
    t.integer "metrics_dashboard_id", limit: 4
  end

  create_table "groups_polls", force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "poll_id",  limit: 4
  end

  create_table "initiative_comments", force: :cascade do |t|
    t.integer  "initiative_id", limit: 4
    t.integer  "user_id",       limit: 4
    t.text     "content",       limit: 65535
    t.boolean  "approved",                    default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "initiative_expenses", force: :cascade do |t|
    t.string   "description",      limit: 191
    t.decimal  "amount",                       precision: 8, scale: 2, default: 0.0
    t.integer  "owner_id",         limit: 4
    t.integer  "initiative_id",    limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.integer  "annual_budget_id", limit: 4
  end

  create_table "initiative_fields", force: :cascade do |t|
    t.integer "initiative_id", limit: 4
    t.integer "field_id",      limit: 4
  end

  create_table "initiative_groups", force: :cascade do |t|
    t.integer "initiative_id", limit: 4
    t.integer "group_id",      limit: 4
  end

  create_table "initiative_invitees", force: :cascade do |t|
    t.integer "initiative_id", limit: 4
    t.integer "user_id",       limit: 4
  end

  create_table "initiative_participating_groups", force: :cascade do |t|
    t.integer "initiative_id", limit: 4
    t.integer "group_id",      limit: 4
  end

  create_table "initiative_segments", force: :cascade do |t|
    t.integer "initiative_id", limit: 4
    t.integer "segment_id",    limit: 4
  end

  create_table "initiative_updates", force: :cascade do |t|
    t.text     "data",          limit: 65535
    t.text     "comments",      limit: 65535
    t.integer  "owner_id",      limit: 4
    t.integer  "initiative_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "report_date"
  end

  create_table "initiative_users", force: :cascade do |t|
    t.integer  "initiative_id", limit: 4
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "outlook_id",    limit: 191
  end

  create_table "initiatives", force: :cascade do |t|
    t.string   "name",                 limit: 191
    t.datetime "start"
    t.datetime "end"
    t.decimal  "estimated_funding",                  precision: 8, scale: 2, default: 0.0,   null: false
    t.integer  "actual_funding",       limit: 4
    t.integer  "owner_id",             limit: 4
    t.integer  "pillar_id",            limit: 4
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.text     "description",          limit: 65535
    t.integer  "max_attendees",        limit: 4
    t.string   "picture_file_name",    limit: 191
    t.string   "picture_content_type", limit: 191
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "owner_group_id",       limit: 4
    t.string   "location",             limit: 191
    t.integer  "budget_item_id",       limit: 4
    t.boolean  "finished_expenses",                                          default: false
    t.datetime "archived_at"
    t.integer  "annual_budget_id",     limit: 4
    t.string   "video_file_name",      limit: 191
    t.string   "video_content_type",   limit: 191
    t.integer  "video_file_size",      limit: 4
    t.datetime "video_updated_at"
  end

  create_table "invitation_segments_groups", force: :cascade do |t|
    t.integer "segment_id", limit: 4
    t.integer "group_id",   limit: 4
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "news_feed_link_id", limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "enterprise_id",     limit: 4
    t.integer  "answer_id",         limit: 4
  end

  add_index "likes", ["answer_id"], name: "index_likes_on_answer_id", using: :btree
  add_index "likes", ["enterprise_id"], name: "index_likes_on_enterprise_id", using: :btree
  add_index "likes", ["news_feed_link_id"], name: "index_likes_on_news_feed_link_id", using: :btree
  add_index "likes", ["user_id", "answer_id", "enterprise_id"], name: "index_likes_on_user_id_and_answer_id_and_enterprise_id", unique: true, using: :btree
  add_index "likes", ["user_id", "news_feed_link_id", "enterprise_id"], name: "index_likes_on_user_id_and_news_feed_link_id_and_enterprise_id", unique: true, using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "mentoring_interests", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.string   "name",          limit: 191, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_request_interests", force: :cascade do |t|
    t.integer  "mentoring_request_id",  limit: 4, null: false
    t.integer  "mentoring_interest_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_requests", force: :cascade do |t|
    t.integer  "enterprise_id",  limit: 4
    t.string   "status",         limit: 191,   default: "pending", null: false
    t.text     "notes",          limit: 65535
    t.integer  "sender_id",      limit: 4,                         null: false
    t.integer  "receiver_id",    limit: 4,                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mentoring_type", limit: 191,   default: "mentor",  null: false
  end

  create_table "mentoring_session_comments", force: :cascade do |t|
    t.text     "content",              limit: 65535
    t.integer  "user_id",              limit: 4
    t.integer  "mentoring_session_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "mentoring_session_comments", ["mentoring_session_id"], name: "index_mentoring_session_comments_on_mentoring_session_id", using: :btree
  add_index "mentoring_session_comments", ["user_id"], name: "index_mentoring_session_comments_on_user_id", using: :btree

  create_table "mentoring_session_topics", force: :cascade do |t|
    t.integer  "mentoring_interest_id", limit: 4, null: false
    t.integer  "mentoring_session_id",  limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_sessions", force: :cascade do |t|
    t.integer  "enterprise_id",   limit: 4
    t.integer  "creator_id",      limit: 4,                           null: false
    t.datetime "start",                                               null: false
    t.datetime "end",                                                 null: false
    t.string   "format",          limit: 191,                         null: false
    t.string   "link",            limit: 191
    t.text     "access_token",    limit: 65535
    t.string   "video_room_name", limit: 191
    t.string   "status",          limit: 191,   default: "scheduled", null: false
    t.text     "notes",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentoring_types", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.string   "name",          limit: 191, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorings", force: :cascade do |t|
    t.integer  "mentor_id",  limit: 4
    t.integer  "mentee_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorship_availabilities", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                      null: false
    t.string   "start",      limit: 191,                    null: false
    t.string   "end",        limit: 191,                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "day",        limit: 191, default: "monday", null: false
  end

  add_index "mentorship_availabilities", ["user_id"], name: "index_mentorship_availabilities_on_user_id", using: :btree

  create_table "mentorship_interests", force: :cascade do |t|
    t.integer  "user_id",               limit: 4, null: false
    t.integer  "mentoring_interest_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorship_ratings", force: :cascade do |t|
    t.integer  "rating",               limit: 4,                     null: false
    t.integer  "user_id",              limit: 4,                     null: false
    t.integer  "mentoring_session_id", limit: 4,                     null: false
    t.boolean  "okrs_achieved",                      default: false
    t.boolean  "valuable",                           default: false
    t.text     "comments",             limit: 65535,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentorship_sessions", force: :cascade do |t|
    t.integer  "user_id",              limit: 4,                       null: false
    t.string   "role",                 limit: 191,                     null: false
    t.integer  "mentoring_session_id", limit: 4,                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",               limit: 191, default: "pending", null: false
  end

  create_table "mentorship_types", force: :cascade do |t|
    t.integer  "user_id",           limit: 4, null: false
    t.integer  "mentoring_type_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "metrics_dashboards", force: :cascade do |t|
    t.integer  "enterprise_id",   limit: 4
    t.string   "name",            limit: 191
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "owner_id",        limit: 4
    t.string   "shareable_token", limit: 191
  end

  create_table "metrics_dashboards_segments", force: :cascade do |t|
    t.integer "metrics_dashboard_id", limit: 4
    t.integer "segment_id",           limit: 4
  end

  create_table "mobile_fields", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.integer  "field_id",      limit: 4
    t.integer  "index",         limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "news_feed_link_segments", force: :cascade do |t|
    t.integer  "news_feed_link_id",         limit: 4
    t.integer  "segment_id",                limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "news_link_segment_id",      limit: 4
    t.integer  "group_messages_segment_id", limit: 4
    t.integer  "social_link_segment_id",    limit: 4
  end

  create_table "news_feed_link_tags", id: false, force: :cascade do |t|
    t.integer "news_feed_link_id", limit: 4
    t.string  "news_tag_name",     limit: 191
  end

  add_index "news_feed_link_tags", ["news_feed_link_id", "news_tag_name"], name: "index_news_feed_link_tags_on_news_feed_link_id_and_news_tag_name", using: :btree
  add_index "news_feed_link_tags", ["news_tag_name", "news_feed_link_id"], name: "index_news_feed_link_tags_on_news_tag_name_and_news_feed_link_id", using: :btree

  create_table "news_feed_links", force: :cascade do |t|
    t.integer  "news_feed_id",     limit: 4
    t.boolean  "approved",                   default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "news_link_id",     limit: 4
    t.integer  "group_message_id", limit: 4
    t.integer  "social_link_id",   limit: 4
    t.boolean  "is_pinned",                  default: false
    t.datetime "archived_at"
    t.integer  "views_count",      limit: 4
    t.integer  "likes_count",      limit: 4
  end

  create_table "news_feeds", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "news_link_comments", force: :cascade do |t|
    t.text     "content",      limit: 65535
    t.integer  "author_id",    limit: 4
    t.integer  "news_link_id", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "approved",                   default: false
  end

  create_table "news_link_photos", force: :cascade do |t|
    t.string   "file_file_name",    limit: 191
    t.string   "file_content_type", limit: 191
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "news_link_id",      limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "news_link_segments", force: :cascade do |t|
    t.integer  "news_link_id", limit: 4
    t.integer  "segment_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "news_links", force: :cascade do |t|
    t.string   "title",                limit: 191
    t.text     "description",          limit: 65535
    t.string   "url",                  limit: 191
    t.integer  "group_id",             limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "picture_file_name",    limit: 191
    t.string   "picture_content_type", limit: 191
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "author_id",            limit: 4
  end

  create_table "news_tags", id: false, force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "outcomes", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "outlook_data", force: :cascade do |t|
    t.integer  "user_id",                    limit: 4
    t.text     "encrypted_token_hash",       limit: 65535
    t.text     "encrypted_token_hash_iv",    limit: 65535
    t.boolean  "auto_add_event_to_calendar",               default: true
    t.boolean  "auto_update_calendar_event",               default: true
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  create_table "page_names", id: false, force: :cascade do |t|
    t.string "page_url",  limit: 191
    t.string "page_name", limit: 191
  end

  add_index "page_names", ["page_name", "page_url"], name: "index_page_names_on_page_name_and_page_url", using: :btree
  add_index "page_names", ["page_url", "page_name"], name: "index_page_names_on_page_url_and_page_name", using: :btree

  create_table "page_visitation_data", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "page_url",     limit: 191
    t.string   "controller",   limit: 191
    t.string   "action",       limit: 191
    t.integer  "visits_day",   limit: 4,   default: 0
    t.integer  "visits_week",  limit: 4,   default: 0
    t.integer  "visits_month", limit: 4,   default: 0
    t.integer  "visits_year",  limit: 4,   default: 0
    t.integer  "visits_all",   limit: 4,   default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "page_visitation_data", ["page_url", "user_id"], name: "index_page_visitation_data_on_page_url_and_user_id", using: :btree
  add_index "page_visitation_data", ["user_id", "page_url"], name: "index_page_visitation_data_on_user_id_and_page_url", using: :btree

  create_table "pillars", force: :cascade do |t|
    t.string   "name",              limit: 191
    t.string   "value_proposition", limit: 191
    t.integer  "outcome_id",        limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "policy_group_templates", force: :cascade do |t|
    t.string   "name",                        limit: 191,                 null: false
    t.boolean  "default",                                 default: false
    t.integer  "user_role_id",                limit: 4
    t.integer  "enterprise_id",               limit: 4
    t.boolean  "campaigns_index",                         default: false
    t.boolean  "campaigns_create",                        default: false
    t.boolean  "campaigns_manage",                        default: false
    t.boolean  "polls_index",                             default: false
    t.boolean  "polls_create",                            default: false
    t.boolean  "polls_manage",                            default: false
    t.boolean  "group_messages_index",                    default: false
    t.boolean  "group_messages_create",                   default: false
    t.boolean  "group_messages_manage",                   default: false
    t.boolean  "groups_index",                            default: false
    t.boolean  "groups_create",                           default: false
    t.boolean  "groups_manage",                           default: false
    t.boolean  "groups_members_index",                    default: false
    t.boolean  "groups_members_manage",                   default: false
    t.boolean  "groups_budgets_index",                    default: false
    t.boolean  "groups_budgets_request",                  default: false
    t.boolean  "metrics_dashboards_index",                default: false
    t.boolean  "metrics_dashboards_create",               default: false
    t.boolean  "news_links_index",                        default: false
    t.boolean  "news_links_create",                       default: false
    t.boolean  "news_links_manage",                       default: false
    t.boolean  "enterprise_resources_index",              default: false
    t.boolean  "enterprise_resources_create",             default: false
    t.boolean  "enterprise_resources_manage",             default: false
    t.boolean  "segments_index",                          default: false
    t.boolean  "segments_create",                         default: false
    t.boolean  "segments_manage",                         default: false
    t.boolean  "users_index",                             default: false
    t.boolean  "users_manage",                            default: false
    t.boolean  "initiatives_index",                       default: false
    t.boolean  "initiatives_create",                      default: false
    t.boolean  "initiatives_manage",                      default: false
    t.boolean  "logs_view",                               default: false
    t.boolean  "branding_manage",                         default: false
    t.boolean  "sso_manage",                              default: false
    t.boolean  "permissions_manage",                      default: false
    t.boolean  "group_leader_manage",                     default: false
    t.boolean  "global_calendar",                         default: false
    t.boolean  "manage_posts",                            default: false
    t.boolean  "diversity_manage",                        default: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.boolean  "budget_approval",                         default: false
    t.boolean  "manage_all",                              default: false
    t.boolean  "enterprise_manage",                       default: false
    t.boolean  "groups_budgets_manage",                   default: false
    t.boolean  "group_leader_index",                      default: false
    t.boolean  "groups_insights_manage",                  default: false
    t.boolean  "groups_layouts_manage",                   default: false
    t.boolean  "group_resources_index",                   default: false
    t.boolean  "group_resources_create",                  default: false
    t.boolean  "group_resources_manage",                  default: false
    t.boolean  "social_links_index",                      default: false
    t.boolean  "social_links_create",                     default: false
    t.boolean  "social_links_manage",                     default: false
    t.boolean  "group_settings_manage",                   default: false
    t.boolean  "group_posts_index",                       default: false
    t.boolean  "mentorship_manage",                       default: false
    t.boolean  "auto_archive_manage",                     default: false
  end

  create_table "policy_groups", force: :cascade do |t|
    t.boolean  "campaigns_index",                       default: false
    t.boolean  "campaigns_create",                      default: false
    t.boolean  "campaigns_manage",                      default: false
    t.boolean  "polls_index",                           default: false
    t.boolean  "polls_create",                          default: false
    t.boolean  "polls_manage",                          default: false
    t.boolean  "group_messages_index",                  default: false
    t.boolean  "group_messages_create",                 default: false
    t.boolean  "group_messages_manage",                 default: false
    t.boolean  "groups_index",                          default: false
    t.boolean  "groups_create",                         default: false
    t.boolean  "groups_manage",                         default: false
    t.boolean  "groups_members_index",                  default: false
    t.boolean  "groups_members_manage",                 default: false
    t.boolean  "groups_budgets_index",                  default: false
    t.boolean  "groups_budgets_request",                default: false
    t.boolean  "metrics_dashboards_index",              default: false
    t.boolean  "metrics_dashboards_create",             default: false
    t.boolean  "news_links_index",                      default: false
    t.boolean  "news_links_create",                     default: false
    t.boolean  "news_links_manage",                     default: false
    t.boolean  "enterprise_resources_index",            default: false
    t.boolean  "enterprise_resources_create",           default: false
    t.boolean  "enterprise_resources_manage",           default: false
    t.boolean  "segments_index",                        default: false
    t.boolean  "segments_create",                       default: false
    t.boolean  "segments_manage",                       default: false
    t.boolean  "users_index",                           default: false
    t.boolean  "users_manage",                          default: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.boolean  "initiatives_index",                     default: false
    t.boolean  "initiatives_create",                    default: false
    t.boolean  "initiatives_manage",                    default: false
    t.boolean  "budget_approval",                       default: false
    t.boolean  "logs_view",                             default: false
    t.boolean  "sso_manage",                            default: false
    t.boolean  "permissions_manage",                    default: false
    t.boolean  "diversity_manage",                      default: false
    t.boolean  "manage_posts",                          default: false
    t.boolean  "group_leader_manage",                   default: false
    t.boolean  "global_calendar",                       default: false
    t.boolean  "branding_manage",                       default: false
    t.integer  "user_id",                     limit: 4
    t.boolean  "manage_all",                            default: false
    t.boolean  "enterprise_manage",                     default: false
    t.boolean  "groups_budgets_manage",                 default: false
    t.boolean  "group_leader_index",                    default: false
    t.boolean  "groups_insights_manage",                default: false
    t.boolean  "groups_layouts_manage",                 default: false
    t.boolean  "group_resources_index",                 default: false
    t.boolean  "group_resources_create",                default: false
    t.boolean  "group_resources_manage",                default: false
    t.boolean  "social_links_index",                    default: false
    t.boolean  "social_links_create",                   default: false
    t.boolean  "social_links_manage",                   default: false
    t.boolean  "group_settings_manage",                 default: false
    t.boolean  "group_posts_index",                     default: false
    t.boolean  "mentorship_manage",                     default: false
    t.boolean  "auto_archive_manage",                   default: false
  end

  add_index "policy_groups", ["user_id"], name: "index_policy_groups_on_user_id", using: :btree

  create_table "poll_responses", force: :cascade do |t|
    t.integer  "poll_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.text     "data",       limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "anonymous",                default: false
  end

  add_index "poll_responses", ["user_id"], name: "index_poll_responses_on_user_id", using: :btree

  create_table "polls", force: :cascade do |t|
    t.string   "title",          limit: 191
    t.text     "description",    limit: 65535
    t.time     "start"
    t.time     "end"
    t.integer  "nb_invitations", limit: 4
    t.integer  "enterprise_id",  limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "owner_id",       limit: 4
    t.integer  "status",         limit: 4,     default: 0,     null: false
    t.boolean  "email_sent",                   default: false, null: false
    t.integer  "initiative_id",  limit: 4
  end

  add_index "polls", ["initiative_id"], name: "index_polls_on_initiative_id", using: :btree

  create_table "polls_segments", force: :cascade do |t|
    t.integer "poll_id",    limit: 4
    t.integer "segment_id", limit: 4
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title",         limit: 191
    t.text     "description",   limit: 65535
    t.integer  "campaign_id",   limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "solved_at"
    t.text     "conclusion",    limit: 65535
    t.integer  "answers_count", limit: 4
  end

  create_table "resources", force: :cascade do |t|
    t.string   "title",                limit: 191
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "file_file_name",       limit: 191
    t.string   "file_content_type",    limit: 191
    t.integer  "file_file_size",       limit: 4
    t.datetime "file_updated_at"
    t.integer  "owner_id",             limit: 4
    t.string   "resource_type",        limit: 191
    t.string   "url",                  limit: 255
    t.integer  "mentoring_session_id", limit: 4
    t.integer  "enterprise_id",        limit: 4
    t.integer  "folder_id",            limit: 4
    t.integer  "group_id",             limit: 4
    t.integer  "initiative_id",        limit: 4
    t.datetime "archived_at"
    t.integer  "views_count",          limit: 4
  end

  create_table "reward_actions", force: :cascade do |t|
    t.string   "label",         limit: 191
    t.integer  "points",        limit: 4
    t.string   "key",           limit: 191
    t.integer  "enterprise_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reward_actions", ["enterprise_id"], name: "index_reward_actions_on_enterprise_id", using: :btree

  create_table "rewards", force: :cascade do |t|
    t.integer  "enterprise_id",        limit: 4,     null: false
    t.integer  "points",               limit: 4,     null: false
    t.string   "label",                limit: 191
    t.string   "picture_file_name",    limit: 191
    t.string   "picture_content_type", limit: 191
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.text     "description",          limit: 65535
    t.integer  "responsible_id",       limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rewards", ["enterprise_id"], name: "index_rewards_on_enterprise_id", using: :btree
  add_index "rewards", ["responsible_id"], name: "index_rewards_on_responsible_id", using: :btree

  create_table "samples", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "samples", ["user_id"], name: "index_samples_on_user_id", using: :btree

  create_table "segment_group_scope_rule_groups", force: :cascade do |t|
    t.integer  "segment_group_scope_rule_id", limit: 4
    t.integer  "group_id",                    limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "segment_group_scope_rule_groups", ["group_id"], name: "index_segment_group_scope_rule_groups_on_group_id", using: :btree
  add_index "segment_group_scope_rule_groups", ["segment_group_scope_rule_id"], name: "segment_group_rule_group_index", using: :btree

  create_table "segment_group_scope_rules", force: :cascade do |t|
    t.integer  "segment_id", limit: 4
    t.integer  "operator",   limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "segment_group_scope_rules", ["segment_id"], name: "index_segment_group_scope_rules_on_segment_id", using: :btree

  create_table "segment_order_rules", force: :cascade do |t|
    t.integer  "segment_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "operator",   limit: 4, null: false
    t.integer  "field",      limit: 4, null: false
  end

  add_index "segment_order_rules", ["segment_id"], name: "index_segment_order_rules_on_segment_id", using: :btree

  create_table "segment_rules", force: :cascade do |t|
    t.integer  "segment_id", limit: 4
    t.integer  "field_id",   limit: 4
    t.integer  "operator",   limit: 4
    t.text     "values",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "segments", force: :cascade do |t|
    t.integer  "enterprise_id",       limit: 4
    t.string   "name",                limit: 191
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "owner_id",            limit: 4
    t.string   "active_users_filter", limit: 191
    t.integer  "limit",               limit: 4
    t.integer  "job_status",          limit: 4,   default: 0, null: false
    t.integer  "parent_id",           limit: 4
  end

  add_index "segments", ["parent_id"], name: "index_segments_on_parent_id", using: :btree

  create_table "shared_metrics_dashboards", force: :cascade do |t|
    t.integer "user_id",              limit: 4
    t.integer "metrics_dashboard_id", limit: 4
  end

  add_index "shared_metrics_dashboards", ["metrics_dashboard_id"], name: "index_shared_metrics_dashboards_on_metrics_dashboard_id", using: :btree
  add_index "shared_metrics_dashboards", ["user_id"], name: "index_shared_metrics_dashboards_on_user_id", using: :btree

  create_table "shared_news_feed_links", force: :cascade do |t|
    t.integer  "news_feed_link_id", limit: 4, null: false
    t.integer  "news_feed_id",      limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sharepoint_data", force: :cascade do |t|
    t.string   "data_type",  limit: 191
    t.text     "data",       limit: 4294967295
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "social_link_segments", force: :cascade do |t|
    t.integer  "social_link_id", limit: 4
    t.integer  "segment_id",     limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "social_network_posts", force: :cascade do |t|
    t.integer  "author_id",        limit: 4
    t.text     "embed_code",       limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "url",              limit: 65535
    t.integer  "group_id",         limit: 4
    t.text     "small_embed_code", limit: 65535
  end

  create_table "sponsors", force: :cascade do |t|
    t.string   "sponsor_name",               limit: 191
    t.string   "sponsor_title",              limit: 191
    t.text     "sponsor_message",            limit: 65535
    t.boolean  "disable_sponsor_message"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "sponsor_media_file_name",    limit: 191
    t.string   "sponsor_media_content_type", limit: 191
    t.integer  "sponsor_media_file_size",    limit: 4
    t.datetime "sponsor_media_updated_at"
    t.integer  "enterprise_id",              limit: 4
    t.integer  "group_id",                   limit: 4
    t.integer  "campaign_id",                limit: 4
  end

  create_table "survey_managers", force: :cascade do |t|
    t.integer "survey_id", limit: 4
    t.integer "user_id",   limit: 4
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",        limit: 191, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "resource_id", limit: 4
  end

  create_table "themes", force: :cascade do |t|
    t.string   "logo_file_name",      limit: 191
    t.string   "logo_content_type",   limit: 191
    t.integer  "logo_file_size",      limit: 4
    t.datetime "logo_updated_at"
    t.string   "primary_color",       limit: 191
    t.string   "digest",              limit: 191
    t.boolean  "default",                         default: false
    t.string   "secondary_color",     limit: 191
    t.boolean  "use_secondary_color",             default: false
    t.string   "logo_redirect_url",   limit: 191
  end

  create_table "topic_feedbacks", force: :cascade do |t|
    t.integer  "topic_id",   limit: 4
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "featured",                 default: false
  end

  create_table "topics", force: :cascade do |t|
    t.text     "statement",     limit: 65535
    t.date     "expiration"
    t.integer  "user_id",       limit: 4
    t.integer  "enterprise_id", limit: 4
    t.integer  "category_id",   limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "twitter_accounts", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.string   "name",       limit: 191
    t.string   "account",    limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "group_id",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted_member",                   default: false
    t.integer  "total_weekly_points", limit: 4,     default: 0
    t.text     "data",                limit: 65535
  end

  create_table "user_reward_actions", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4, null: false
    t.integer  "reward_action_id",         limit: 4, null: false
    t.integer  "operation",                limit: 4, null: false
    t.integer  "points",                   limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "initiative_id",            limit: 4
    t.integer  "initiative_comment_id",    limit: 4
    t.integer  "group_message_id",         limit: 4
    t.integer  "group_message_comment_id", limit: 4
    t.integer  "news_link_id",             limit: 4
    t.integer  "news_link_comment_id",     limit: 4
    t.integer  "social_link_id",           limit: 4
    t.integer  "answer_comment_id",        limit: 4
    t.integer  "answer_upvote_id",         limit: 4
    t.integer  "answer_id",                limit: 4
    t.integer  "poll_response_id",         limit: 4
  end

  add_index "user_reward_actions", ["operation"], name: "index_user_reward_actions_on_operation", using: :btree
  add_index "user_reward_actions", ["reward_action_id"], name: "index_user_reward_actions_on_reward_action_id", using: :btree
  add_index "user_reward_actions", ["user_id"], name: "index_user_reward_actions_on_user_id", using: :btree

  create_table "user_rewards", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     null: false
    t.integer  "reward_id",  limit: 4,     null: false
    t.integer  "points",     limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",     limit: 4
    t.text     "comment",    limit: 65535
  end

  add_index "user_rewards", ["reward_id"], name: "index_user_rewards_on_reward_id", using: :btree
  add_index "user_rewards", ["user_id"], name: "index_user_rewards_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.boolean  "default",                   default: false
    t.string   "role_name",     limit: 191
    t.string   "role_type",     limit: 191, default: "non_admin"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "priority",      limit: 4,                         null: false
  end

  add_index "user_roles", ["enterprise_id"], name: "index_user_roles_on_enterprise_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                     limit: 191
    t.string   "last_name",                      limit: 191
    t.text     "data",                           limit: 65535
    t.string   "auth_source",                    limit: 191
    t.integer  "enterprise_id",                  limit: 4
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "email",                          limit: 191
    t.string   "notifications_email",            limit: 191
    t.string   "encrypted_password",             limit: 191
    t.string   "reset_password_token",           limit: 191
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",             limit: 191
    t.string   "last_sign_in_ip",                limit: 191
    t.string   "invitation_token",               limit: 191
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",               limit: 4
    t.integer  "invited_by_id",                  limit: 4
    t.string   "invited_by_type",                limit: 191
    t.integer  "invitations_count",              limit: 4,     default: 0
    t.string   "provider",                       limit: 191
    t.string   "uid",                            limit: 191
    t.text     "tokens",                         limit: 65535
    t.string   "firebase_token",                 limit: 191
    t.datetime "firebase_token_generated_at"
    t.integer  "participation_score_7days",      limit: 4,     default: 0
    t.string   "yammer_token",                   limit: 191
    t.string   "linkedin_profile_url",           limit: 191
    t.string   "avatar_file_name",               limit: 191
    t.string   "avatar_content_type",            limit: 191
    t.integer  "avatar_file_size",               limit: 4
    t.datetime "avatar_updated_at"
    t.boolean  "active",                                       default: true
    t.text     "biography",                      limit: 65535
    t.integer  "points",                         limit: 4,     default: 0,     null: false
    t.integer  "credits",                        limit: 4,     default: 0,     null: false
    t.string   "time_zone",                      limit: 191
    t.integer  "total_weekly_points",            limit: 4,     default: 0
    t.integer  "failed_attempts",                limit: 4,     default: 0,     null: false
    t.string   "unlock_token",                   limit: 191
    t.datetime "locked_at"
    t.boolean  "custom_policy_group",                          default: false, null: false
    t.integer  "user_role_id",                   limit: 4
    t.boolean  "mentee",                                       default: false
    t.boolean  "mentor",                                       default: false
    t.text     "mentorship_description",         limit: 65535
    t.integer  "groups_notifications_frequency", limit: 4,     default: 2
    t.integer  "groups_notifications_date",      limit: 4,     default: 5
    t.boolean  "accepting_mentor_requests",                    default: true
    t.boolean  "accepting_mentee_requests",                    default: true
    t.datetime "last_group_notification_date"
    t.boolean  "seen_onboarding",                              default: false
    t.integer  "initiatives_count",              limit: 4
    t.integer  "social_links_count",             limit: 4
    t.integer  "own_messages_count",             limit: 4
    t.integer  "own_news_links_count",           limit: 4
    t.integer  "answer_comments_count",          limit: 4
    t.integer  "message_comments_count",         limit: 4
    t.integer  "news_link_comments_count",       limit: 4
    t.integer  "mentors_count",                  limit: 4
    t.integer  "mentees_count",                  limit: 4
  end

  add_index "users", ["active"], name: "index_users_on_active", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_segments", force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "segment_id", limit: 4
  end

  add_index "users_segments", ["user_id"], name: "index_users_segments_on_user_id", using: :btree

  create_table "views", force: :cascade do |t|
    t.integer  "user_id",           limit: 4, null: false
    t.integer  "news_feed_link_id", limit: 4
    t.integer  "enterprise_id",     limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "group_id",          limit: 4
    t.integer  "folder_id",         limit: 4
    t.integer  "resource_id",       limit: 4
    t.integer  "view_count",        limit: 4
  end

  create_table "yammer_field_mappings", force: :cascade do |t|
    t.integer  "enterprise_id",     limit: 4
    t.string   "yammer_field_name", limit: 191
    t.integer  "diverst_field_id",  limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_foreign_key "annual_budgets", "enterprises"
  add_foreign_key "annual_budgets", "groups"
  add_foreign_key "badges", "enterprises"
  add_foreign_key "budgets", "users", column: "approver_id"
  add_foreign_key "budgets", "users", column: "requester_id"
  add_foreign_key "custom_texts", "enterprises"
  add_foreign_key "enterprises", "sharepoint_data", column: "share_point_files_id"
  add_foreign_key "enterprises", "sharepoint_data", column: "share_point_lists_id"
  add_foreign_key "enterprises", "sharepoint_data", column: "share_point_pages_id"
  add_foreign_key "groups", "sharepoint_data", column: "share_point_files_id"
  add_foreign_key "groups", "sharepoint_data", column: "share_point_lists_id"
  add_foreign_key "groups", "sharepoint_data", column: "share_point_pages_id"
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

  create_view "duplicate_page_names", sql_definition: <<-SQL
      select `page_names`.`page_url` AS `page_url`,`page_names`.`page_name` AS `page_name` from `page_names` where `page_names`.`page_name` in (select `page_names`.`page_name` from `page_names` group by `page_names`.`page_name` having (count(0) > 1))
  SQL
  create_view "unique_page_names", sql_definition: <<-SQL
      select `page_names`.`page_url` AS `page_url`,`page_names`.`page_name` AS `page_name` from `page_names` where `page_names`.`page_name` in (select `page_names`.`page_name` from `page_names` group by `page_names`.`page_name` having (count(0) = 1))
  SQL
  create_view "page_visitation_by_names", sql_definition: <<-SQL
      (select `a`.`user_id` AS `user_id`,`b`.`page_name` AS `page_name`,NULL AS `page_url`,sum(`a`.`visits_day`) AS `visits_day`,sum(`a`.`visits_week`) AS `visits_week`,sum(`a`.`visits_month`) AS `visits_month`,sum(`a`.`visits_year`) AS `visits_year`,sum(`a`.`visits_all`) AS `visits_all` from (`page_visitation_data` `a` join `duplicate_page_names` `b` on((`a`.`page_url` = `b`.`page_url`))) group by `a`.`user_id`,`b`.`page_name`) union all (select `a`.`user_id` AS `user_id`,`b`.`page_name` AS `page_name`,`a`.`page_url` AS `page_url`,sum(`a`.`visits_day`) AS `visits_day`,sum(`a`.`visits_week`) AS `visits_week`,sum(`a`.`visits_month`) AS `visits_month`,sum(`a`.`visits_year`) AS `visits_year`,sum(`a`.`visits_all`) AS `visits_all` from (`page_visitation_data` `a` join `unique_page_names` `b` on((`a`.`page_url` = `b`.`page_url`))) group by `a`.`user_id`,`b`.`page_url`,`b`.`page_name`)
  SQL
  create_view "page_visitations", sql_definition: <<-SQL
      select `a`.`id` AS `id`,`a`.`user_id` AS `user_id`,`a`.`page_url` AS `page_url`,`a`.`controller` AS `controller`,`a`.`action` AS `action`,`a`.`visits_day` AS `visits_day`,`a`.`visits_week` AS `visits_week`,`a`.`visits_month` AS `visits_month`,`a`.`visits_year` AS `visits_year`,`a`.`visits_all` AS `visits_all`,`a`.`created_at` AS `created_at`,`a`.`updated_at` AS `updated_at`,`b`.`page_name` AS `page_name` from (`page_visitation_data` `a` join `page_names` `b` on((`a`.`page_url` = `b`.`page_url`)))
  SQL
  create_view "total_page_visitation_by_names", sql_definition: <<-SQL
      (select `b`.`page_name` AS `page_name`,NULL AS `page_url`,sum(`a`.`visits_day`) AS `visits_day`,sum(`a`.`visits_week`) AS `visits_week`,sum(`a`.`visits_month`) AS `visits_month`,sum(`a`.`visits_year`) AS `visits_year`,sum(`a`.`visits_all`) AS `visits_all` from ((`page_visitation_data` `a` join `duplicate_page_names` `b` on((`a`.`page_url` = `b`.`page_url`))) join `users` `c` on((`c`.`id` = `a`.`user_id`))) group by `b`.`page_name`,`c`.`enterprise_id`) union all (select `b`.`page_name` AS `page_name`,`a`.`page_url` AS `page_url`,sum(`a`.`visits_day`) AS `visits_day`,sum(`a`.`visits_week`) AS `visits_week`,sum(`a`.`visits_month`) AS `visits_month`,sum(`a`.`visits_year`) AS `visits_year`,sum(`a`.`visits_all`) AS `visits_all` from ((`page_visitation_data` `a` join `unique_page_names` `b` on((`a`.`page_url` = `b`.`page_url`))) join `users` `c` on((`c`.`id` = `a`.`user_id`))) group by `b`.`page_url`,`b`.`page_name`,`c`.`enterprise_id`)
  SQL
  create_view "total_page_visitations", sql_definition: <<-SQL
      select `a`.`page_url` AS `page_url`,`b`.`page_name` AS `page_name`,`c`.`enterprise_id` AS `enterprise_id`,sum(`a`.`visits_day`) AS `visits_day`,sum(`a`.`visits_week`) AS `visits_week`,sum(`a`.`visits_month`) AS `visits_month`,sum(`a`.`visits_year`) AS `visits_year`,sum(`a`.`visits_all`) AS `visits_all` from ((`page_visitation_data` `a` join `page_names` `b` on((`a`.`page_url` = `b`.`page_url`))) join `users` `c` on((`c`.`id` = `a`.`user_id`))) group by `a`.`page_url`,`b`.`page_name`,`c`.`enterprise_id`
  SQL
end
