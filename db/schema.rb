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

ActiveRecord::Schema.define(version: 2021_01_12_002153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "disabled", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cpf"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "adoptions", force: :cascade do |t|
    t.bigint "giver_id", null: false
    t.bigint "adopter_id"
    t.bigint "associate_id"
    t.bigint "pet_id", null: false
    t.string "status"
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["adopter_id"], name: "index_adoptions_on_adopter_id"
    t.index ["associate_id"], name: "index_adoptions_on_associate_id"
    t.index ["giver_id"], name: "index_adoptions_on_giver_id"
    t.index ["pet_id"], name: "index_adoptions_on_pet_id"
  end

  create_table "associates", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "blacklisted_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "expire_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "admin_user_id"
    t.bigint "user_id"
    t.index ["admin_user_id"], name: "index_blacklisted_tokens_on_admin_user_id"
    t.index ["user_id"], name: "index_blacklisted_tokens_on_user_id"
  end

  create_table "favorited_pets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pet_id"], name: "index_favorited_pets_on_pet_id"
    t.index ["user_id"], name: "index_favorited_pets_on_user_id"
  end

  create_table "pets", force: :cascade do |t|
    t.string "name", null: false
    t.string "kind", null: false
    t.string "breed", null: false
    t.string "gender", null: false
    t.integer "age", null: false
    t.integer "height", null: false
    t.integer "weight", null: false
    t.boolean "neutered", null: false
    t.boolean "dewormed", null: false
    t.boolean "vaccinated", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "can_be_adopted", default: false
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "admin_user_id"
    t.bigint "user_id"
    t.index ["admin_user_id"], name: "index_refresh_tokens_on_admin_user_id"
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role"
    t.boolean "active", default: true
    t.bigint "admin_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_user_id"], name: "index_roles_on_admin_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cpf"
    t.string "cnpj"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adoptions", "associates"
  add_foreign_key "adoptions", "pets"
  add_foreign_key "adoptions", "users", column: "adopter_id"
  add_foreign_key "adoptions", "users", column: "giver_id"
  add_foreign_key "blacklisted_tokens", "admin_users"
  add_foreign_key "blacklisted_tokens", "users"
  add_foreign_key "favorited_pets", "pets"
  add_foreign_key "favorited_pets", "users"
  add_foreign_key "pets", "users"
  add_foreign_key "refresh_tokens", "admin_users"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "roles", "admin_users"
end
