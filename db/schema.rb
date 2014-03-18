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

ActiveRecord::Schema.define(version: 20140316181731) do

  create_table "conferences", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "gameID"
    t.string   "date"
    t.string   "homeTeam"
    t.string   "awayTeam"
    t.float    "homePoints"
    t.float    "homefgm"
    t.float    "homefga"
    t.float    "homefgPer"
    t.float    "hometwoMade"
    t.float    "hometwoAtt"
    t.float    "hometwoPer"
    t.float    "homethreeMade"
    t.float    "homethreeAtt"
    t.float    "homethreePer"
    t.float    "homeftm"
    t.float    "homefta"
    t.float    "homeftPer"
    t.float    "homeoffReb"
    t.float    "homedefReb"
    t.float    "hometotalReb"
    t.float    "homepps"
    t.float    "homeadjFG"
    t.float    "homeassist"
    t.float    "hometo"
    t.float    "homeapto"
    t.float    "homesteals"
    t.float    "homefouls"
    t.float    "homestealPerTO"
    t.float    "homestealPerFoul"
    t.float    "homeblocks"
    t.float    "homeblocksPerFoul"
    t.float    "awaypoints"
    t.float    "awayfgm"
    t.float    "awayfga"
    t.float    "awayfgPer"
    t.float    "awaytwoMade"
    t.float    "awaytwoAtt"
    t.float    "awaytwoPer"
    t.float    "awaythreeMade"
    t.float    "awaythreeAtt"
    t.float    "awaythreePer"
    t.float    "awayftm"
    t.float    "awayfta"
    t.float    "awayftPer"
    t.float    "awayoffReb"
    t.float    "awaydefReb"
    t.float    "awaytotalReb"
    t.float    "awaypps"
    t.float    "awayadjFG"
    t.float    "awayassist"
    t.float    "awayto"
    t.float    "awayapto"
    t.float    "awaysteals"
    t.float    "awayfouls"
    t.float    "awaystealPerTO"
    t.float    "awaystealPerFoul"
    t.float    "awayblocks"
    t.float    "awayblocksPerFoul"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.string   "date"
    t.string   "location"
    t.string   "opponent"
    t.boolean  "isWinner"
    t.integer  "teamScore"
    t.integer  "oppScore"
    t.integer  "temp_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["temp_team_id"], name: "index_schedules_on_temp_team_id"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["conference_id"], name: "index_teams_on_conference_id"

  create_table "temp_teams", force: true do |t|
    t.string   "name"
    t.string   "webExt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
