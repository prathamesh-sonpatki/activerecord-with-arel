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

ActiveRecord::Schema.define(version: 20140621041229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: true do |t|
    t.integer  "traveler_id", null: false
    t.integer  "location_id", null: false
    t.integer  "no_of_days"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name",                 null: false
    t.string   "area"
    t.string   "location_type"
    t.integer  "parent_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "distance_from_parent"
  end

  create_table "reviews", force: true do |t|
    t.string   "comment",     limit: 5000
    t.integer  "rating",                   default: 3
    t.integer  "traveler_id",                          null: false
    t.integer  "location_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.integer  "traveler_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed",    default: false
    t.datetime "completed_at"
  end

  create_table "travelers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "name"
    t.string   "sekret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
