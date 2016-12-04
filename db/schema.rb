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

ActiveRecord::Schema.define(version: 20161204100904) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "submission_id"
    t.datetime "apply_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["submission_id"], name: "index_interests_on_submission_id", using: :btree
  end

  create_table "job_offers", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.date     "start_date"
    t.integer  "company_id"
    t.integer  "category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "description_additional"
    t.string   "formatted_location"
    t.string   "city"
    t.string   "country"
    t.datetime "date"
    t.string   "source_primary"
    t.string   "source_original"
    t.text     "url_source_primary"
    t.text     "url_source_original"
    t.string   "jobkey"
    t.boolean  "expired"
    t.boolean  "approved"
    t.index ["category_id"], name: "index_job_offers_on_category_id", using: :btree
    t.index ["company_id"], name: "index_job_offers_on_company_id", using: :btree
  end

  create_table "job_preferences", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_job_preferences_on_category_id", using: :btree
    t.index ["user_id"], name: "index_job_preferences_on_user_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_offer_id"
    t.datetime "read_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["job_offer_id"], name: "index_submissions_on_job_offer_id", using: :btree
    t.index ["user_id"], name: "index_submissions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "messenger_uid"
    t.boolean  "driver_licence"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_foreign_key "interests", "submissions"
  add_foreign_key "job_offers", "categories"
  add_foreign_key "job_offers", "companies"
  add_foreign_key "job_preferences", "categories"
  add_foreign_key "job_preferences", "users"
  add_foreign_key "submissions", "job_offers"
  add_foreign_key "submissions", "users"
end
