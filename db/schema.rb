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

ActiveRecord::Schema.define(version: 20170413151827) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "answer_comments", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.integer  "answer_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
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
    t.string   "supporting_document_file_name",    limit: 255
    t.string   "supporting_document_content_type", limit: 255
    t.integer  "supporting_document_file_size",    limit: 4
    t.datetime "supporting_document_updated_at"
  end

  create_table "badges", force: :cascade do |t|
    t.integer  "enterprise_id",      limit: 4,   null: false
    t.integer  "points",             limit: 4,   null: false
    t.string   "label",              limit: 255, null: false
    t.string   "image_file_name",    limit: 255, null: false
    t.string   "image_content_type", limit: 255, null: false
    t.integer  "image_file_size",    limit: 4,   null: false
    t.datetime "image_updated_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges", ["enterprise_id"], name: "index_badges_on_enterprise_id", using: :btree

  create_table "biases", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4
    t.text     "from_data",                limit: 65535
    t.text     "to_data",                  limit: 65535
    t.boolean  "anonymous",                              default: true
    t.integer  "severity",                 limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",              limit: 65535
    t.boolean  "spoken_words",                           default: false
    t.boolean  "marginalized_in_meetings",               default: false
    t.boolean  "called_name",                            default: false
    t.boolean  "contributions_ignored",                  default: false
    t.boolean  "in_documents",                           default: false
    t.boolean  "unfairly_criticized",                    default: false
    t.boolean  "sexual_harassment",                      default: false
    t.boolean  "inequality",                             default: false
  end

  create_table "biases_from_cities", force: :cascade do |t|
    t.integer "bias_id", limit: 4
    t.integer "city_id", limit: 4
  end

  create_table "biases_from_departments", force: :cascade do |t|
    t.integer "bias_id",       limit: 4
    t.integer "department_id", limit: 4
  end

  create_table "biases_from_groups", force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "bias_id",  limit: 4
  end

  create_table "biases_to_cities", force: :cascade do |t|
    t.integer "bias_id", limit: 4
    t.integer "city_id", limit: 4
  end

  create_table "biases_to_departments", force: :cascade do |t|
    t.integer "bias_id",       limit: 4
    t.integer "department_id", limit: 4
  end

  create_table "biases_to_groups", force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "bias_id",  limit: 4
  end

  create_table "budget_items", force: :cascade do |t|
    t.integer  "budget_id",        limit: 4
    t.string   "title",            limit: 255
    t.date     "estimated_date"
    t.boolean  "is_done",                                              default: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.decimal  "estimated_amount",             precision: 8, scale: 2
    t.decimal  "available_amount",             precision: 8, scale: 2, default: 0.0
  end

  create_table "budgets", force: :cascade do |t|
    t.integer  "subject_id",   limit: 4
    t.string   "subject_type", limit: 255
    t.text     "description",  limit: 65535
    t.boolean  "is_approved"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "approver_id",  limit: 4
    t.integer  "requester_id", limit: 4
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
    t.string   "title",               limit: 255
    t.text     "description",         limit: 65535
    t.datetime "start"
    t.datetime "end"
    t.integer  "nb_invites",          limit: 4
    t.integer  "enterprise_id",       limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_file_name",     limit: 255
    t.string   "image_content_type",  limit: 255
    t.integer  "image_file_size",     limit: 4
    t.datetime "image_updated_at"
    t.string   "banner_file_name",    limit: 255
    t.string   "banner_content_type", limit: 255
    t.integer  "banner_file_size",    limit: 4
    t.datetime "banner_updated_at"
    t.integer  "owner_id",            limit: 4
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
    t.string   "title",          limit: 255
    t.boolean  "is_done",                    default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "container_id",   limit: 4
    t.string   "container_type", limit: 255
  end

  add_index "checklist_items", ["container_type", "container_id"], name: "index_checklist_items_on_container_type_and_container_id", using: :btree

  create_table "checklists", force: :cascade do |t|
    t.integer  "subject_id",   limit: 4
    t.string   "subject_type", limit: 255
    t.string   "title",        limit: 255
    t.integer  "author_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "departments", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4,   null: false
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string   "token",      limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "platform",   limit: 255
  end

  create_table "email_variables", force: :cascade do |t|
    t.integer  "email_id",    limit: 4
    t.string   "key",         limit: 255
    t.text     "description", limit: 65535
    t.boolean  "required"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "slug",                 limit: 255
    t.boolean  "use_custom_templates"
    t.text     "custom_html_template", limit: 65535
    t.text     "custom_txt_template",  limit: 65535
    t.integer  "enterprise_id",        limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "subject",              limit: 255
  end

  create_table "enterprises", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.string   "sp_entity_id",                 limit: 255
    t.string   "idp_entity_id",                limit: 255
    t.string   "idp_sso_target_url",           limit: 255
    t.string   "idp_slo_target_url",           limit: 255
    t.text     "idp_cert",                     limit: 65535
    t.string   "saml_first_name_mapping",      limit: 255
    t.string   "saml_last_name_mapping",       limit: 255
    t.boolean  "has_enabled_saml"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "yammer_token",                 limit: 255
    t.boolean  "yammer_import",                              default: false
    t.boolean  "yammer_group_sync",                          default: false
    t.integer  "theme_id",                     limit: 4
    t.string   "cdo_name",                     limit: 255
    t.string   "cdo_title",                    limit: 255
    t.string   "cdo_picture_file_name",        limit: 255
    t.string   "cdo_picture_content_type",     limit: 255
    t.integer  "cdo_picture_file_size",        limit: 4
    t.datetime "cdo_picture_updated_at"
    t.text     "cdo_message",                  limit: 65535
    t.text     "cdo_message_email",            limit: 65535
    t.boolean  "collaborate_module_enabled",                 default: true,  null: false
    t.boolean  "scope_module_enabled",                       default: true,  null: false
    t.boolean  "bias_module_enabled",                        default: false, null: false
    t.boolean  "plan_module_enabled",                        default: true,  null: false
    t.string   "banner_file_name",             limit: 255
    t.string   "banner_content_type",          limit: 255
    t.integer  "banner_file_size",             limit: 4
    t.datetime "banner_updated_at"
    t.text     "privacy_statement",            limit: 65535
    t.boolean  "has_enabled_onboarding_email",               default: true
    t.string   "xml_sso_config_file_name",     limit: 255
    t.string   "xml_sso_config_content_type",  limit: 255
    t.integer  "xml_sso_config_file_size",     limit: 4
    t.datetime "xml_sso_config_updated_at"
  end

  create_table "event_attendances", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "event_comments", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "user_id",  limit: 4
    t.text    "content",  limit: 65535
  end

  create_table "event_fields", force: :cascade do |t|
    t.integer "field_id", limit: 4
    t.integer "event_id", limit: 4
  end

  create_table "event_invitees", force: :cascade do |t|
    t.integer "event_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.text     "description",          limit: 65535
    t.datetime "start"
    t.datetime "end"
    t.string   "location",             limit: 255
    t.integer  "max_attendees",        limit: 4
    t.integer  "group_id",             limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "owner_id",             limit: 4
  end

  create_table "events_segments", force: :cascade do |t|
    t.integer "event_id",   limit: 4
    t.integer "segment_id", limit: 4
  end

  create_table "expense_categories", force: :cascade do |t|
    t.integer  "enterprise_id",     limit: 4
    t.string   "name",              limit: 255
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size",    limit: 4
    t.datetime "icon_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "enterprise_id", limit: 4
    t.string  "name",          limit: 255
    t.integer "price",         limit: 4
    t.boolean "income",                    default: false
    t.integer "category_id",   limit: 4
  end

  create_table "fields", force: :cascade do |t|
    t.string   "type",               limit: 255
    t.string   "title",              limit: 255
    t.integer  "gamification_value", limit: 4,     default: 1
    t.boolean  "show_on_vcard"
    t.string   "saml_attribute",     limit: 255
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
    t.integer  "container_id",       limit: 4
    t.string   "container_type",     limit: 255
    t.boolean  "elasticsearch_only",               default: false
    t.boolean  "required",                         default: false
  end

  add_index "fields", ["container_type", "container_id"], name: "index_fields_on_container_type_and_container_id", using: :btree

  create_table "graphs", force: :cascade do |t|
    t.integer  "field_id",           limit: 4
    t.integer  "aggregation_id",     limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "collection_id",      limit: 4
    t.string   "collection_type",    limit: 255
    t.string   "custom_field",       limit: 255
    t.string   "custom_aggregation", limit: 255
    t.boolean  "time_series",                    default: false
    t.datetime "range_from"
    t.datetime "range_to"
  end

  add_index "graphs", ["collection_type", "collection_id"], name: "index_graphs_on_collection_type_and_collection_id", using: :btree

  create_table "group_fields", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.integer  "field_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "group_leaders", force: :cascade do |t|
    t.integer  "group_id",      limit: 4
    t.integer  "user_id",       limit: 4
    t.string   "position_name", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "group_message_comments", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.integer  "message_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "group_messages", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.string   "subject",    limit: 255
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
    t.integer  "enterprise_id",             limit: 4
    t.string   "name",                      limit: 255
    t.text     "description",               limit: 65535
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
    t.string   "logo_file_name",            limit: 255
    t.string   "logo_content_type",         limit: 255
    t.integer  "logo_file_size",            limit: 4
    t.datetime "logo_updated_at"
    t.boolean  "send_invitations"
    t.integer  "participation_score_7days", limit: 4
    t.boolean  "yammer_create_group"
    t.boolean  "yammer_group_created"
    t.string   "yammer_group_name",         limit: 255
    t.boolean  "yammer_sync_users"
    t.integer  "yammer_id",                 limit: 4
    t.integer  "manager_id",                limit: 4
    t.integer  "owner_id",                  limit: 4
    t.integer  "lead_manager_id",           limit: 4
    t.string   "pending_users",             limit: 255
    t.string   "members_visibility",        limit: 255
    t.string   "messages_visibility",       limit: 255
    t.decimal  "annual_budget",                           precision: 8, scale: 2
    t.decimal  "leftover_money",                          precision: 8, scale: 2, default: 0.0
    t.string   "banner_file_name",          limit: 255
    t.string   "banner_content_type",       limit: 255
    t.integer  "banner_file_size",          limit: 4
    t.datetime "banner_updated_at"
    t.string   "calendar_color",            limit: 255
  end

  create_table "groups_managers", force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  create_table "groups_metrics_dashboards", force: :cascade do |t|
    t.integer "group_id",             limit: 4
    t.integer "metrics_dashboard_id", limit: 4
  end

  create_table "groups_polls", force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "poll_id",  limit: 4
  end

  create_table "initiative_comments", force: :cascade do |t|
    t.integer "initiative_id", limit: 4
    t.integer "user_id",       limit: 4
    t.text    "content",       limit: 65535
  end

  create_table "initiative_expenses", force: :cascade do |t|
    t.string   "description",   limit: 255
    t.integer  "amount",        limit: 4
    t.integer  "owner_id",      limit: 4
    t.integer  "initiative_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
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
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "initiatives", force: :cascade do |t|
    t.string   "name",                 limit: 255
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
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "owner_group_id",       limit: 4
    t.string   "location",             limit: 255
    t.integer  "budget_item_id",       limit: 4
    t.boolean  "finished_expenses",                                          default: false
  end

  create_table "invitation_segments_groups", force: :cascade do |t|
    t.integer "segment_id", limit: 4
    t.integer "group_id",   limit: 4
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "user1_id",            limit: 4
    t.integer  "user2_id",            limit: 4
    t.integer  "user1_status",        limit: 4,  default: 0
    t.integer  "user2_status",        limit: 4,  default: 0
    t.float    "score",               limit: 24
    t.time     "score_calculated_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "archived",                       default: false
    t.integer  "topic_id",            limit: 4
    t.integer  "user1_rating",        limit: 4
    t.integer  "user2_rating",        limit: 4
    t.datetime "both_accepted_at"
  end

  create_table "metrics_dashboards", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "owner_id",      limit: 4
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

  create_table "news_link_comments", force: :cascade do |t|
    t.text     "content",      limit: 65535
    t.integer  "author_id",    limit: 4
    t.integer  "news_link_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "news_links", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.string   "description",          limit: 255
    t.string   "url",                  limit: 255
    t.integer  "group_id",             limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.integer  "author_id",            limit: 4
  end

  create_table "outcomes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pillars", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "value_proposition", limit: 255
    t.integer  "outcome_id",        limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "policy_groups", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.integer  "enterprise_id",               limit: 4
    t.boolean  "campaigns_index",                         default: false
    t.boolean  "campaigns_create",                        default: false
    t.boolean  "campaigns_manage",                        default: false
    t.boolean  "polls_index",                             default: false
    t.boolean  "polls_create",                            default: false
    t.boolean  "polls_manage",                            default: false
    t.boolean  "events_index",                            default: false
    t.boolean  "events_create",                           default: false
    t.boolean  "events_manage",                           default: false
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
    t.boolean  "global_settings_manage",                  default: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.boolean  "initiatives_index",                       default: false
    t.boolean  "initiatives_create",                      default: false
    t.boolean  "initiatives_manage",                      default: false
    t.boolean  "default_for_enterprise",                  default: false
    t.boolean  "admin_pages_view",                        default: false
    t.boolean  "budget_approval",                         default: false
    t.boolean  "logs_view",                               default: false
  end

  create_table "poll_responses", force: :cascade do |t|
    t.integer  "poll_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.text     "data",       limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "anonymous",                default: false
  end

  create_table "polls", force: :cascade do |t|
    t.string   "title",          limit: 255
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
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "campaign_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "solved_at"
    t.text     "conclusion",  limit: 65535
  end

  create_table "resources", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.integer  "container_id",      limit: 4
    t.string   "container_type",    limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "owner_id",          limit: 4
  end

  add_index "resources", ["container_type", "container_id"], name: "index_resources_on_container_type_and_container_id", using: :btree

  create_table "reward_actions", force: :cascade do |t|
    t.string   "label",         limit: 255, null: false
    t.integer  "points",        limit: 4
    t.string   "key",           limit: 255, null: false
    t.integer  "enterprise_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reward_actions", ["enterprise_id"], name: "index_reward_actions_on_enterprise_id", using: :btree

  create_table "rewards", force: :cascade do |t|
    t.integer  "enterprise_id",        limit: 4,     null: false
    t.integer  "points",               limit: 4,     null: false
    t.string   "label",                limit: 255,   null: false
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
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

  create_table "segment_rules", force: :cascade do |t|
    t.integer  "segment_id", limit: 4
    t.integer  "field_id",   limit: 4
    t.integer  "operator",   limit: 4
    t.string   "values",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "segments", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "owner_id",      limit: 4
  end

  create_table "survey_managers", force: :cascade do |t|
    t.integer "survey_id", limit: 4
    t.integer "user_id",   limit: 4
  end

  create_table "themes", force: :cascade do |t|
    t.string   "logo_file_name",      limit: 255
    t.string   "logo_content_type",   limit: 255
    t.integer  "logo_file_size",      limit: 4
    t.datetime "logo_updated_at"
    t.string   "primary_color",       limit: 255
    t.string   "digest",              limit: 255
    t.boolean  "default",                         default: false
    t.string   "secondary_color",     limit: 255
    t.boolean  "use_secondary_color",             default: false
    t.string   "logo_redirect_url",   limit: 255, default: ""
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

  create_table "user_groups", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "group_id",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted_member",               default: false
    t.boolean  "enable_notification",           default: true
  end

  create_table "user_reward_actions", force: :cascade do |t|
    t.integer  "user_id",          limit: 4,   null: false
    t.integer  "reward_action_id", limit: 4,   null: false
    t.integer  "entity_id",        limit: 4
    t.string   "entity_type",      limit: 255
    t.integer  "operation",        limit: 4,   null: false
    t.integer  "points",           limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_reward_actions", ["operation"], name: "index_user_reward_actions_on_operation", using: :btree
  add_index "user_reward_actions", ["reward_action_id"], name: "index_user_reward_actions_on_reward_action_id", using: :btree
  add_index "user_reward_actions", ["user_id"], name: "index_user_reward_actions_on_user_id", using: :btree

  create_table "user_rewards", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "reward_id",  limit: 4, null: false
    t.integer  "points",     limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_rewards", ["reward_id"], name: "index_user_rewards_on_reward_id", using: :btree
  add_index "user_rewards", ["user_id"], name: "index_user_rewards_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                  limit: 255
    t.string   "last_name",                   limit: 255
    t.text     "data",                        limit: 65535
    t.string   "auth_source",                 limit: 255
    t.integer  "enterprise_id",               limit: 4
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "email",                       limit: 255,   default: "",      null: false
    t.string   "encrypted_password",          limit: 255,   default: ""
    t.string   "reset_password_token",        limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",          limit: 255
    t.string   "last_sign_in_ip",             limit: 255
    t.string   "invitation_token",            limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",            limit: 4
    t.integer  "invited_by_id",               limit: 4
    t.string   "invited_by_type",             limit: 255
    t.integer  "invitations_count",           limit: 4,     default: 0
    t.string   "provider",                    limit: 255,   default: "email", null: false
    t.string   "uid",                         limit: 255,   default: "",      null: false
    t.text     "tokens",                      limit: 65535
    t.string   "firebase_token",              limit: 255
    t.datetime "firebase_token_generated_at"
    t.integer  "participation_score_7days",   limit: 4,     default: 0
    t.string   "yammer_token",                limit: 255
    t.string   "linkedin_profile_url",        limit: 255
    t.string   "avatar_file_name",            limit: 255
    t.string   "avatar_content_type",         limit: 255
    t.integer  "avatar_file_size",            limit: 4
    t.datetime "avatar_updated_at"
    t.integer  "policy_group_id",             limit: 4
    t.boolean  "active",                                    default: true
    t.text     "biography",                   limit: 65535
    t.integer  "points",                      limit: 4,     default: 0,       null: false
    t.integer  "credits",                     limit: 4,     default: 0,       null: false
  end

  add_index "users", ["active"], name: "index_users_on_active", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_segments", force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.integer "segment_id", limit: 4
  end

  create_table "yammer_field_mappings", force: :cascade do |t|
    t.integer  "enterprise_id",     limit: 4
    t.string   "yammer_field_name", limit: 255
    t.integer  "diverst_field_id",  limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_foreign_key "badges", "enterprises"
  add_foreign_key "budgets", "users", column: "approver_id"
  add_foreign_key "budgets", "users", column: "requester_id"
  add_foreign_key "polls", "initiatives"
  add_foreign_key "reward_actions", "enterprises"
  add_foreign_key "rewards", "enterprises"
  add_foreign_key "rewards", "users", column: "responsible_id"
  add_foreign_key "user_reward_actions", "reward_actions"
  add_foreign_key "user_reward_actions", "users"
  add_foreign_key "user_rewards", "rewards"
  add_foreign_key "user_rewards", "users"
end
