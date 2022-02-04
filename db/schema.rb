# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_02_163929) do

  create_table "endpoints", force: :cascade do |t|
    t.integer "route_id", null: false
    t.float "lat"
    t.float "lon"
    t.string "label"
    t.string "color"
    t.integer "position", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["route_id"], name: "index_endpoints_on_route_id"
  end

  create_table "legends", force: :cascade do |t|
    t.integer "poster_id", null: false
    t.string "title", default: "MY TREK"
    t.string "subtitle", default: "Description"
    t.string "labels"
    t.boolean "position", default: true
    t.boolean "disposition", default: true
    t.string "text_color", default: "#222"
    t.integer "height", default: 300
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["poster_id"], name: "index_legends_on_poster_id"
  end

  create_table "posters", force: :cascade do |t|
    t.string "email"
    t.integer "height", default: 2480
    t.integer "width", default: 3508
    t.integer "padding", default: 0
    t.boolean "elevation_profile", default: true
    t.string "elevation_color", default: "#222"
    t.integer "elevation_height", default: 248
    t.string "theme", default: "mapbox://styles/mapbox/streets-v11"
    t.string "background", default: "#F7F7F7"
    t.string "bounds"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "routes", force: :cascade do |t|
    t.integer "poster_id", null: false
    t.string "name"
    t.boolean "elevation", default: true
    t.integer "thickness", default: 8
    t.string "color1", default: "#FF6"
    t.string "color2", default: "#300"
    t.integer "sort_index", default: 0
    t.string "gpx_track"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["poster_id"], name: "index_routes_on_poster_id"
  end

  add_foreign_key "endpoints", "routes"
  add_foreign_key "legends", "posters"
  add_foreign_key "routes", "posters"
end
