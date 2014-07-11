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

ActiveRecord::Schema.define(version: 20140709182211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.integer  "week_id"
    t.integer  "month_id"
    t.integer  "year_id"
    t.date     "date"
    t.string   "url"
    t.string   "headline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tc_id"
    t.string   "author"
  end

  add_index "articles", ["month_id"], name: "index_articles_on_month_id", using: :btree
  add_index "articles", ["week_id"], name: "index_articles_on_week_id", using: :btree
  add_index "articles", ["year_id"], name: "index_articles_on_year_id", using: :btree

  create_table "month_counts", force: true do |t|
    t.integer  "wordbank_id"
    t.integer  "month_id"
    t.integer  "total_count"
    t.integer  "headline_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "month_counts", ["month_id"], name: "index_month_counts_on_month_id", using: :btree
  add_index "month_counts", ["wordbank_id"], name: "index_month_counts_on_wordbank_id", using: :btree

  create_table "months", force: true do |t|
    t.date     "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "week_counts", force: true do |t|
    t.integer  "wordbank_id"
    t.integer  "week_id"
    t.integer  "total_count"
    t.integer  "headline_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "week_counts", ["week_id"], name: "index_week_counts_on_week_id", using: :btree
  add_index "week_counts", ["wordbank_id"], name: "index_week_counts_on_wordbank_id", using: :btree

  create_table "weeks", force: true do |t|
    t.date     "week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wordbanks", force: true do |t|
    t.string   "word"
    t.boolean  "brand"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "year_counts", force: true do |t|
    t.integer  "wordbank_id"
    t.integer  "year_id"
    t.integer  "total_count"
    t.integer  "headline_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "year_counts", ["wordbank_id"], name: "index_year_counts_on_wordbank_id", using: :btree
  add_index "year_counts", ["year_id"], name: "index_year_counts_on_year_id", using: :btree

  create_table "years", force: true do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
