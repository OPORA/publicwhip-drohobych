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

ActiveRecord::Schema.define(version: 20180725103828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "division_infos", force: :cascade do |t|
    t.integer "division_id"
    t.integer "aye_votes"
    t.integer "no_votes"
    t.integer "absent"
    t.integer "against"
    t.integer "abstain"
    t.integer "possible_turnout"
    t.integer "turnout"
    t.integer "rebellions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.date "date"
    t.string "number"
    t.text "name"
    t.string "clock_time"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mp_friends", force: :cascade do |t|
    t.integer "deputy_id"
    t.integer "friend_deputy_id"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_mp_friend"
  end

  create_table "mp_infos", force: :cascade do |t|
    t.integer "deputy_id"
    t.integer "rebellions"
    t.integer "not_voted"
    t.integer "absent"
    t.integer "against"
    t.integer "aye_voted"
    t.integer "abstain"
    t.integer "votes_possible"
    t.integer "votes_attended"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_mp_info"
  end

  create_table "mps", force: :cascade do |t|
    t.integer "deputy_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "faction"
    t.integer "okrug"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_mps_on_id", unique: true
  end

  create_table "party_friends", force: :cascade do |t|
    t.string "party"
    t.string "friend_party"
    t.date "date_party_friend"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "policies", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "provisional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "policy_divisions", force: :cascade do |t|
    t.bigint "policy_id"
    t.bigint "division_id"
    t.string "support"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_policy_divisions_on_division_id"
    t.index ["policy_id"], name: "index_policy_divisions_on_policy_id"
  end

  create_table "policy_person_distances", force: :cascade do |t|
    t.bigint "policy_id"
    t.integer "deputy_id"
    t.integer "same", default: 0, null: false
    t.integer "diff", default: 0, null: false
    t.integer "absent", default: 0, null: false
    t.integer "same_strong", default: 0, null: false
    t.integer "diff_strong", default: 0, null: false
    t.integer "absent_strong", default: 0, null: false
    t.float "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["policy_id"], name: "index_policy_person_distances_on_policy_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "user_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "policy_id"
    t.integer "division_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "vote_factions", force: :cascade do |t|
    t.string "faction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "division_id"
    t.boolean "aye", default: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer "division_id"
    t.integer "deputy_id"
    t.string "vote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whips", force: :cascade do |t|
    t.integer "division_id"
    t.string "party"
    t.integer "aye_votes"
    t.integer "no_votes"
    t.integer "absent"
    t.integer "against"
    t.integer "abstain"
    t.string "whip_guess"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "division_infos", "divisions"
  add_foreign_key "policy_divisions", "divisions"
  add_foreign_key "policy_divisions", "policies"
  add_foreign_key "policy_person_distances", "policies"
  add_foreign_key "votes", "divisions"
  add_foreign_key "votes", "mps", column: "deputy_id"
  add_foreign_key "whips", "divisions"
end
