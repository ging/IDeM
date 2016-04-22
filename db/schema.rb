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

ActiveRecord::Schema.define(version: 20160422075419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "contact_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "type"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "file_processing"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "pdfps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "pcount"
    t.boolean  "permanent",           default: false
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", force: :cascade do |t|
    t.integer  "publication_id"
    t.integer  "author_id"
    t.string   "title"
    t.text     "json"
    t.boolean  "draft",                   default: false
    t.text     "thumbnail_url"
    t.text     "description"
    t.integer  "visit_count",             default: 0
    t.string   "language"
    t.integer  "age_min",                 default: 0
    t.integer  "age_max",                 default: 0
    t.integer  "license_id"
    t.datetime "scorm2004_timestamp"
    t.datetime "scorm12_timestamp"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.text     "tag_array_text",          default: ""
  end

  create_table "publications", force: :cascade do |t|
    t.string   "publication_type"
    t.text     "title"
    t.text     "abstract"
    t.text     "publication_date"
    t.text     "authors_name"
    t.text     "publication_name"
    t.string   "issn"
    t.string   "isbn"
    t.string   "volume"
    t.string   "issue"
    t.text     "loop_data"
    t.text     "loop_url"
    t.integer  "loop_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "tag_array_text",   default: ""
  end

  create_table "publications_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "publication_id"
  end

  create_table "recordings", force: :cascade do |t|
    t.integer  "publication_id"
    t.integer  "webinar_id"
    t.text     "recording_id"
    t.integer  "author_id"
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.text     "tag_array_text", default: ""
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.string  "plain_name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "language"
    t.string   "ui_language"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "ug_password_flag",       default: true
    t.text     "loop_data"
    t.text     "loop_profile_url"
    t.text     "loop_avatar_url"
    t.text     "tag_array_text",         default: ""
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "webinars", force: :cascade do |t|
    t.integer  "publication_id"
    t.integer  "author_id"
    t.text     "room_id"
    t.text     "title"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.text     "tag_array_text", default: ""
  end

end
