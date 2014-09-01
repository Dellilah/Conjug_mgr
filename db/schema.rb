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

ActiveRecord::Schema.define(version: 20140822215453) do

  create_table "forms", force: true do |t|
    t.string   "content"
    t.integer  "temp"
    t.integer  "person"
    t.integer  "verb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forms", ["verb_id"], name: "index_forms_on_verb_id"

  create_table "pgroups", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pgroups", ["user_id"], name: "index_pgroups_on_user_id"

  create_table "repetitions", force: true do |t|
    t.datetime "next"
    t.integer  "count",      default: 1
    t.integer  "mistake",    default: 0
    t.integer  "n",          default: 1
    t.float    "ef",         default: 2.5
    t.integer  "interval",   default: 1
    t.integer  "remembered"
    t.integer  "form_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repetitions", ["form_id", "user_id"], name: "index_repetitions_on_form_id_and_user_id", unique: true

  create_table "translations", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "verb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["verb_id", "user_id"], name: "index_translations_on_verb_id_and_user_id", unique: true

  create_table "ugroups", force: true do |t|
    t.integer  "pgroup_id"
    t.integer  "verb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ugroups", ["verb_id", "pgroup_id"], name: "index_ugroups_on_verb_id_and_pgroup_id", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "user"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "verbs", force: true do |t|
    t.string   "infinitive"
    t.string   "translation"
    t.integer  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
