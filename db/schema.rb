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

ActiveRecord::Schema.define(version: 20150119022350) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "content"
    t.text     "markdown_content"
    t.integer  "user_id"
    t.string   "author"
    t.string   "img"
    t.datetime "publish_time"
    t.integer  "cat_id"
    t.integer  "is_hot"
    t.integer  "is_published"
    t.integer  "is_recommend"
    t.integer  "can_comment"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "address"
    t.string   "speaker"
    t.string   "emcee"
    t.string   "organizer"
    t.string   "sponsor"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cats", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "secret_field"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img"
  end

  create_table "comments", force: true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "commissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "commission_money"
    t.string   "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "group_id"
    t.integer  "group_count"
    t.string   "unit_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "product_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "limit_people_count"
    t.integer  "limit_product_count"
    t.text     "description"
    t.string   "price"
    t.string   "saveup"
    t.string   "discount"
    t.integer  "people"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "limit_per_person"
    t.integer  "remain"
    t.integer  "is_commission"
  end

  create_table "integrals", force: true do |t|
    t.integer  "user_id"
    t.string   "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.string   "rise"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "orders", force: true do |t|
    t.integer  "invoice_id"
    t.integer  "user_id"
    t.string   "order_number"
    t.string   "ship_address"
    t.string   "ship_method"
    t.string   "payment_method"
    t.string   "freight"
    t.string   "package_charge"
    t.string   "total_price"
    t.datetime "buy_date"
    t.integer  "order_status"
    t.integer  "pay_status"
    t.integer  "logistics_status"
    t.integer  "operator"
    t.string   "cancel_reason"
    t.string   "weixin_open_id"
    t.string   "receive_name"
    t.string   "mobile"
    t.string   "tel"
    t.integer  "supplier_id"
    t.string   "order_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invite_code"
    t.string   "share_link_code"
    t.string   "express_number"
    t.string   "express_company"
    t.string   "express_company_number"
  end

  create_table "prize_acts", force: true do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "prize_type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "is_open"
    t.integer  "join_num"
    t.integer  "person_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prize_configs", force: true do |t|
    t.string   "prize_act_id"
    t.string   "prize_name"
    t.string   "min"
    t.string   "max"
    t.string   "prize_content"
    t.integer  "prize_inventory"
    t.integer  "chance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prize_user_numbers", force: true do |t|
    t.integer  "user_id"
    t.integer  "number"
    t.integer  "prize_act_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prize_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "prize_config_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geted"
  end

  create_table "product_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "product_count"
    t.string   "unit_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "price"
    t.string   "img"
    t.integer  "cat_id"
    t.text     "description"
    t.string   "brand"
    t.datetime "expiration_date"
    t.string   "country"
    t.string   "package_type"
    t.string   "product_model"
    t.integer  "status"
    t.string   "profit"
    t.string   "vip_price"
    t.integer  "is_new"
    t.integer  "is_boutique"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fright"
    t.integer  "is_commission"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "is_locked"
    t.integer  "parent_id"
    t.integer  "supplier_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "mobile"
    t.string   "tel"
    t.string   "province"
    t.string   "city"
    t.string   "region"
    t.string   "address"
    t.string   "fax"
    t.string   "invite_code"
    t.string   "share_link_code"
    t.integer  "default_address_id"
    t.string   "weixin_open_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "seckill_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "seckill_id"
    t.integer  "seckill_count"
    t.string   "unit_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seckills", force: true do |t|
    t.integer  "product_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "limit_people_count"
    t.integer  "limit_product_count"
    t.text     "description"
    t.string   "price"
    t.string   "saveup"
    t.string   "discount"
    t.integer  "people"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "limit_per_person"
    t.integer  "remain"
    t.integer  "is_commission"
  end

  create_table "shipaddresses", force: true do |t|
    t.integer  "user_id"
    t.string   "receive_name"
    t.string   "province"
    t.string   "city"
    t.string   "region"
    t.string   "address"
    t.string   "postcode"
    t.string   "tel"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_configs", force: true do |t|
    t.string   "key"
    t.string   "val"
    t.string   "img"
    t.string   "config_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "vritualcards", force: true do |t|
    t.integer  "user_id"
    t.string   "money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withdraws", force: true do |t|
    t.integer  "user_id"
    t.string   "bank_card"
    t.string   "alipay"
    t.string   "we_chat_payment"
    t.string   "draw_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "draw_money"
    t.integer  "draw_status"
    t.integer  "from_user_id"
  end

  create_table "wx_menus", force: true do |t|
    t.string   "name"
    t.text     "msg"
    t.string   "url"
    t.integer  "msg_or_url"
    t.string   "button_type"
    t.string   "key"
    t.integer  "parent_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
