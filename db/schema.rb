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

ActiveRecord::Schema.define(version: 20150921213523) do

  create_table "admins", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.integer  "enterprise_id",          limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
    t.integer  "platform",    limit: 4
    t.string   "token",       limit: 255
    t.integer  "employee_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.text     "data",                   limit: 65535
    t.string   "auth_source",            limit: 255
    t.integer  "enterprise_id",          limit: 4
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "email",                  limit: 255,   default: "",      null: false
    t.string   "encrypted_password",     limit: 255,   default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,     default: 0
    t.string   "provider",               limit: 255,   default: "email", null: false
    t.string   "uid",                    limit: 255,   default: "",      null: false
    t.text     "tokens",                 limit: 65535
    t.string   "firebase_token",         limit: 255
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["invitation_token"], name: "index_employees_on_invitation_token", unique: true, using: :btree
  add_index "employees", ["invitations_count"], name: "index_employees_on_invitations_count", using: :btree
  add_index "employees", ["invited_by_id"], name: "index_employees_on_invited_by_id", using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree

  create_table "employees_groups", force: :cascade do |t|
    t.integer "employee_id", limit: 4
    t.integer "group_id",    limit: 4
  end

  create_table "enterprises", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "idp_entity_id",      limit: 255
    t.string   "idp_sso_target_url", limit: 255
    t.string   "idp_slo_target_url", limit: 255
    t.text     "idp_cert",           limit: 65535
    t.boolean  "has_enabled_saml",   limit: 1
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string   "type",               limit: 255
    t.string   "title",              limit: 255
    t.integer  "gamification_value", limit: 4,     default: 1
    t.boolean  "show_on_vcard",      limit: 1
    t.string   "saml_attribute",     limit: 255
    t.text     "options_text",       limit: 65535
    t.integer  "min",                limit: 4
    t.integer  "max",                limit: 4
    t.boolean  "match_exclude",      limit: 1
    t.boolean  "match_polarity",     limit: 1
    t.float    "match_weight",       limit: 24
    t.integer  "enterprise_id",      limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "alternative_layout", limit: 1,     default: false
  end

  create_table "group_rules", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.integer  "field_id",   limit: 4
    t.integer  "operator",   limit: 4
    t.string   "values",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "enterprise_id", limit: 4
    t.string   "name",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
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
    t.time     "both_accepted_at"
    t.boolean  "archived",            limit: 1,  default: false
    t.integer  "topic_id",            limit: 4
    t.integer  "user1_rating",        limit: 4
    t.integer  "user2_rating",        limit: 4
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "author_id",    limit: 4
    t.integer  "recipient_id", limit: 4
    t.text     "content",      limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "topic_feedbacks", force: :cascade do |t|
    t.integer  "topic_id",    limit: 4
    t.text     "content",     limit: 65535
    t.integer  "employee_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "featured",    limit: 1
  end

  create_table "topics", force: :cascade do |t|
    t.text     "statement",     limit: 65535
    t.date     "expiration"
    t.integer  "admin_id",      limit: 4
    t.integer  "enterprise_id", limit: 4
    t.integer  "category_id",   limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
