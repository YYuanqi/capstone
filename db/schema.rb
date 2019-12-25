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

ActiveRecord::Schema.define(version: 2019_12_25_070911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "caption"
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_images_on_creator_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "role_name", null: false
    t.string "mname"
    t.integer "mid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mid"], name: "index_roles_on_mid"
    t.index ["mname", "mid"], name: "index_roles_on_mname_and_mid"
    t.index ["mname"], name: "index_roles_on_mname"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "thing_images", force: :cascade do |t|
    t.bigint "image_id", null: false
    t.bigint "thing_id", null: false
    t.integer "priority", default: 5, null: false
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id", "thing_id"], name: "index_thing_images_on_image_id_and_thing_id", unique: true
    t.index ["image_id"], name: "index_thing_images_on_image_id"
    t.index ["thing_id"], name: "index_thing_images_on_thing_id"
  end

  create_table "things", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_things_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
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
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "roles", "users"
  add_foreign_key "thing_images", "images"
  add_foreign_key "thing_images", "things"
end
