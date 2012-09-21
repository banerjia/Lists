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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120919172316) do

  create_table "sites", :force => true do |t|
    t.string   "title",        :limit => 300,                :null => false
    t.string   "domain",       :limit => 250,                :null => false
    t.integer  "videos_count", :limit => 2,   :default => 0, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "sites", ["videos_count"], :name => "index_sites_on_videos_count"

  create_table "tags", :id => false, :force => true do |t|
    t.string   "tag",        :default => "porn", :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "tags", ["tag"], :name => "index_tags_on_tag", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "title",       :limit => 200,                     :null => false
    t.text     "description"
    t.string   "url",         :limit => 300,                     :null => false
    t.string   "image_url",   :limit => 500
    t.integer  "rating",      :limit => 1
    t.string   "tags",        :limit => 6999
    t.boolean  "active",                      :default => false, :null => false
    t.integer  "site_id",     :limit => 2
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "videos", ["active"], :name => "index_videos_on_active"
  add_index "videos", ["rating"], :name => "index_videos_on_rating"
  add_index "videos", ["site_id"], :name => "index_videos_on_site_id"

end
