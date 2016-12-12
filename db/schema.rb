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

ActiveRecord::Schema.define(version: 20161211191331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.string   "alias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "user_has_follow"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "title"
    t.string   "src"
    t.integer  "active",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.float    "long"
    t.float    "lat"
    t.string   "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.integer  "category_id"
    t.string   "title"
    t.text     "body"
    t.json     "data",        default: {"comments"=>0, "rates"=>[0, 0, 0, 0, 0]}, null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.string   "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.integer  "admin",           default: 0
    t.string   "password_digest"
    t.string   "name"
    t.string   "date_of_birth"
    t.integer  "sex"
    t.string   "reset_token"
    t.string   "remember_token"
    t.string   "avatar"
    t.string   "cover"
    t.string   "status"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "bookmarks", "posts", on_delete: :cascade
  add_foreign_key "bookmarks", "users", on_delete: :cascade
  add_foreign_key "comments", "posts", on_delete: :cascade
  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "follows", "users", column: "user_has_follow", on_delete: :cascade
  add_foreign_key "follows", "users", on_delete: :cascade
  add_foreign_key "images", "posts", on_delete: :cascade
  add_foreign_key "images", "users", on_delete: :cascade
  add_foreign_key "posts", "categories", on_delete: :cascade
  add_foreign_key "posts", "locations", on_delete: :cascade
  add_foreign_key "posts", "users", on_delete: :cascade
  add_foreign_key "rates", "posts", on_delete: :cascade
  add_foreign_key "rates", "users", on_delete: :cascade
  add_foreign_key "reports", "posts", on_delete: :cascade
  add_foreign_key "reports", "users", on_delete: :cascade
end
