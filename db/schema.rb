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

ActiveRecord::Schema.define(version: 20140501143116) do

  create_table "forms", force: true do |t|
    t.string   "content"
    t.integer  "temp"
    t.integer  "person"
    t.integer  "verb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forms", ["verb_id"], name: "index_forms_on_verb_id"

  create_table "repetitions", force: true do |t|
    t.datetime "last"
    t.integer  "count"
    t.integer  "mistake"
    t.integer  "correct"
    t.integer  "form_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repetitions", ["form_id", "user_id"], name: "index_repetitions_on_form_id_and_user_id", unique: true

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "pass"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "verbs", force: true do |t|
    t.string   "infinitive"
    t.string   "translation"
    t.integer  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
