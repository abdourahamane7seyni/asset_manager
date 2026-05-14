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

ActiveRecord::Schema[7.1].define(version: 2026_05_13_115522) do
  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.string "asset_type"
    t.string "brand"
    t.string "model"
    t.string "serial_number"
    t.string "status"
    t.date "purchase_date"
    t.date "warranty_expiry"
    t.string "assigned_to"
    t.string "location"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decharges", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "statut"
    t.date "date_emission"
    t.date "date_signature"
    t.text "notes"
    t.string "fichier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_decharges_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "department"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materiels", force: :cascade do |t|
    t.string "nom"
    t.string "type_materiel"
    t.string "marque"
    t.string "modele"
    t.string "numero_serie"
    t.string "statut"
    t.date "date_achat"
    t.date "expiration_garantie"
    t.string "assigne_a"
    t.string "localisation"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movements", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "action"
    t.date "date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "materiel_id", default: 0, null: false
    t.index ["employee_id"], name: "index_movements_on_employee_id"
    t.index ["materiel_id"], name: "index_movements_on_materiel_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "decharges", "employees"
  add_foreign_key "movements", "employees"
  add_foreign_key "movements", "materiels"
end
