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

ActiveRecord::Schema.define(version: 20171018171604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer "api_id"
    t.string "ip"
    t.bigint "subnet_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subnet_id"], name: "index_addresses_on_subnet_id"
  end

  create_table "aggregates", force: :cascade do |t|
    t.string "name"
    t.float "space_total"
    t.float "space_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "storage_box_id"
    t.index ["storage_box_id"], name: "index_aggregates_on_storage_box_id"
  end

  create_table "clusters", force: :cascade do |t|
    t.float "cpu_total"
    t.float "cpu_used"
    t.float "memory_total"
    t.float "memory_used"
    t.bigint "data_center_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.float "disk_total"
    t.float "disk_used"
    t.integer "physical_cores"
    t.integer "virtual_cores"
    t.integer "hosts_total"
    t.integer "hosts_active"
    t.index ["data_center_id"], name: "index_clusters_on_data_center_id"
  end

  create_table "data_centers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "disk_total"
    t.float "disk_used"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "hosts", force: :cascade do |t|
    t.float "cpu_total"
    t.float "cpu_used"
    t.float "memory_total"
    t.float "memory_used"
    t.bigint "cluster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.float "disk_total"
    t.float "disk_used"
    t.integer "physical_cores"
    t.integer "virtual_cores"
    t.index ["cluster_id"], name: "index_hosts_on_cluster_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "storage_boxes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subnets", force: :cascade do |t|
    t.integer "api_id"
    t.string "base"
    t.integer "mask"
    t.bigint "section_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_hosts", default: 0
    t.boolean "public"
    t.index ["section_id"], name: "index_subnets_on_section_id"
  end

  create_table "volumes", force: :cascade do |t|
    t.string "name"
    t.float "space_total"
    t.float "space_used"
    t.bigint "aggregate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aggregate_id"], name: "index_volumes_on_aggregate_id"
  end

  add_foreign_key "addresses", "subnets"
  add_foreign_key "aggregates", "storage_boxes"
  add_foreign_key "clusters", "data_centers"
  add_foreign_key "hosts", "clusters"
  add_foreign_key "subnets", "sections"
  add_foreign_key "volumes", "aggregates"
end
