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

ActiveRecord::Schema.define(version: 20130827015937) do

  create_table "contest_admins", force: true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contest_admins", ["contest_id"], name: "index_contest_admins_on_contest_id"
  add_index "contest_admins", ["user_id"], name: "index_contest_admins_on_user_id"

  create_table "contest_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contest_users", ["contest_id"], name: "index_contest_users_on_contest_id"
  add_index "contest_users", ["user_id"], name: "index_contest_users_on_user_id"

  create_table "contests", force: true do |t|
    t.string   "name"
    t.datetime "begin"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", force: true do |t|
    t.integer  "memory"
    t.integer  "result_id"
    t.integer  "state_id"
    t.integer  "time"
    t.string   "input"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "details", ["result_id"], name: "index_details_on_result_id"

  create_table "inputs", force: true do |t|
    t.integer  "task_id"
    t.string   "dir_name"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inputs", ["task_id"], name: "index_inputs_on_task_id"

  create_table "results", force: true do |t|
    t.integer  "lang_id"
    t.text     "message"
    t.integer  "state_id"
    t.integer  "user_id"
    t.integer  "task_id"
    t.integer  "contest_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["contest_id"], name: "index_results_on_contest_id"
  add_index "results", ["task_id"], name: "index_results_on_task_id"
  add_index "results", ["user_id"], name: "index_results_on_user_id"

  create_table "states", force: true do |t|
    t.string   "state_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submits", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.integer  "tl"
    t.integer  "ml"
    t.text     "body"
    t.string   "serial"
    t.integer  "judge_type"
    t.integer  "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["contest_id"], name: "index_tasks_on_contest_id"
  add_index "tasks", ["serial", "contest_id"], name: "index_tasks_on_serial_and_contest_id", unique: true

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",          default: "user"
  end

end
