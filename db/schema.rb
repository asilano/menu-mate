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

ActiveRecord::Schema[7.1].define(version: 2024_05_19_214327) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_active_sessions_on_user_id"
  end

  create_table "menu_plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_menu_plans_on_user_id"
  end

  create_table "plan_day_restrictions", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "plan_day_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_day_id"], name: "index_plan_day_restrictions_on_plan_day_id"
    t.index ["tag_id"], name: "index_plan_day_restrictions_on_tag_id"
  end

  create_table "plan_days", force: :cascade do |t|
    t.bigint "menu_plan_id", null: false
    t.integer "day_number"
    t.bigint "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_plan_id"], name: "index_plan_days_on_menu_plan_id"
    t.index ["recipe_id"], name: "index_plan_days_on_recipe_id"
  end

  create_table "recipe_properties", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_properties_on_recipe_id"
    t.index ["tag_id"], name: "index_recipe_properties_on_tag_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_recipes_on_name"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "google_userid", null: false
    t.string "email", null: false
    t.string "name"
    t.string "first_name"
    t.string "picture_uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_userid"], name: "index_users_on_google_userid", unique: true
  end

  add_foreign_key "active_sessions", "users", on_delete: :cascade
  add_foreign_key "menu_plans", "users"
  add_foreign_key "plan_day_restrictions", "plan_days"
  add_foreign_key "plan_day_restrictions", "tags"
  add_foreign_key "plan_days", "menu_plans"
  add_foreign_key "plan_days", "recipes"
  add_foreign_key "recipe_properties", "recipes"
  add_foreign_key "recipe_properties", "tags"
  add_foreign_key "recipes", "users", on_delete: :cascade
  add_foreign_key "tags", "users"
end
