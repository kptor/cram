# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_03_22_174057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_multiple_choice_choices", force: :cascade do |t|
    t.bigint "activity_multiple_choice_id", null: false
    t.string "label", null: false
    t.boolean "correct", default: false, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_multiple_choice_id", "position"], name: "idx_mc_choices_on_mc_id_and_position"
    t.index ["activity_multiple_choice_id"], name: "idx_on_activity_multiple_choice_id_b7c4fd45d6"
  end

  create_table "activity_multiple_choices", force: :cascade do |t|
    t.text "prompt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activity_parts", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.integer "position", default: 0, null: false
    t.string "partable_type", null: false
    t.bigint "partable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "position"], name: "index_activity_parts_on_activity_id_and_position"
    t.index ["activity_id"], name: "index_activity_parts_on_activity_id"
    t.index ["partable_type", "partable_id"], name: "index_activity_parts_on_partable"
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id", "user_id"], name: "index_assignments_on_activity_id_and_user_id", unique: true
    t.index ["activity_id"], name: "index_assignments_on_activity_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "users"
  add_foreign_key "activity_multiple_choice_choices", "activity_multiple_choices"
  add_foreign_key "activity_parts", "activities"
  add_foreign_key "assignments", "activities"
  add_foreign_key "assignments", "users"
end
