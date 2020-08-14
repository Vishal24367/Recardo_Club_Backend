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

ActiveRecord::Schema.define(version: 2020_08_10_010623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ar_classes", force: :cascade do |t|
    t.string "name"
    t.integer "strength"
    t.bigint "organization_id"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_ar_classes_on_department_id"
    t.index ["name"], name: "index_ar_classes_on_name"
    t.index ["organization_id"], name: "index_ar_classes_on_organization_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "authorizations", force: :cascade do |t|
    t.string "name"
    t.string "authorization_type"
    t.string "route_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_departments_on_organization_id"
  end

  create_table "employee_records", force: :cascade do |t|
    t.string "employee_code"
    t.datetime "timestamp_update"
    t.datetime "timestamp_hiring"
    t.string "hiring_code"
    t.string "mobile"
    t.text "address"
    t.string "location"
    t.string "resume_id"
    t.datetime "joining_date"
    t.datetime "releaving_date"
    t.integer "trigger_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.index ["employee_code"], name: "index_employee_records_on_employee_code"
    t.index ["timestamp_hiring"], name: "index_employee_records_on_timestamp_hiring"
    t.index ["timestamp_update"], name: "index_employee_records_on_timestamp_update"
  end

  create_table "employee_roles", force: :cascade do |t|
    t.integer "role_id", null: false
    t.bigint "user_id"
    t.bigint "ar_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ar_class_id"], name: "index_employee_roles_on_ar_class_id"
    t.index ["role_id"], name: "index_employee_roles_on_role_id"
    t.index ["user_id"], name: "index_employee_roles_on_user_id"
  end

  create_table "lectures", force: :cascade do |t|
    t.string "name"
    t.string "topic_name"
    t.integer "duration"
    t.string "video_link"
    t.bigint "ar_class_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ar_class_id"], name: "index_lectures_on_ar_class_id"
    t.index ["user_id"], name: "index_lectures_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id"
    t.bigint "department_id"
    t.jsonb "configurations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_roles_on_department_id"
    t.index ["organization_id"], name: "index_roles_on_organization_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "year", default: 0
    t.string "roll_no"
    t.string "section"
    t.string "language"
    t.string "skills"
    t.string "contact_no"
    t.string "codingPlatform"
    t.string "handleNames"
    t.string "dataStructureKnowledge"
    t.bigint "department_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_students_on_department_id"
    t.index ["year"], name: "index_students_on_year"
  end

  create_table "user_authorizations", force: :cascade do |t|
    t.boolean "is_active", default: true
    t.bigint "user_id"
    t.bigint "authorization_id"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorization_id"], name: "index_user_authorizations_on_authorization_id"
    t.index ["organization_id"], name: "index_user_authorizations_on_organization_id"
    t.index ["user_id"], name: "index_user_authorizations_on_user_id"
  end

  create_table "user_auths", id: :serial, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "designation"
    t.integer "status", default: 0
    t.integer "department_id"
    t.integer "organization_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "employee_code"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ar_classes", "departments"
  add_foreign_key "ar_classes", "organizations"
  add_foreign_key "departments", "organizations"
  add_foreign_key "employee_roles", "ar_classes"
  add_foreign_key "employee_roles", "roles"
  add_foreign_key "employee_roles", "users"
  add_foreign_key "lectures", "ar_classes"
  add_foreign_key "lectures", "users"
  add_foreign_key "roles", "departments"
  add_foreign_key "roles", "organizations"
  add_foreign_key "students", "departments"
  add_foreign_key "user_authorizations", "authorizations"
  add_foreign_key "user_authorizations", "organizations"
  add_foreign_key "user_authorizations", "users"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "organizations"
end
