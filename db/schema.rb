# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100405145419) do

  create_table "affiliations", :force => true do |t|
    t.integer  "resume_id",                   :null => false
    t.integer  "position",     :default => 0, :null => false
    t.date     "start_date",                  :null => false
    t.date     "end_date"
    t.string   "organization",                :null => false
    t.string   "relationship",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "model"
    t.string   "serial"
    t.float    "cost"
    t.float    "value"
    t.float    "price"
    t.boolean  "for_sale",    :default => false
    t.date     "acquired_on"
    t.date     "used_on"
    t.date     "sold_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "user_id",                          :null => false
    t.boolean  "hide",          :default => false
    t.boolean  "public",        :default => true,  :null => false
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entries_count", :default => 0,     :null => false
  end

  create_table "boards", :force => true do |t|
    t.string   "title"
    t.integer  "user_id",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",        :default => true,  :null => false
    t.boolean  "hide",          :default => false
    t.integer  "magnets_count", :default => 0,     :null => false
  end

  create_table "categories", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assets_count", :default => 0, :null => false
  end

  add_index "categories", ["name", "user_id"], :name => "by_name", :unique => true

  create_table "category_taggings", :force => true do |t|
    t.integer "asset_id"
    t.integer "category_id"
  end

  add_index "category_taggings", ["asset_id"], :name => "by_asset_id"
  add_index "category_taggings", ["category_id"], :name => "by_category_id"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "connect_fours", :force => true do |t|
    t.integer  "player_1_id",       :null => false
    t.integer  "player_2_id",       :null => false
    t.integer  "turn_id"
    t.integer  "winner_id"
    t.text     "marshaled_squares"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creator_taggings", :force => true do |t|
    t.integer "asset_id"
    t.integer "creator_id"
  end

  add_index "creator_taggings", ["asset_id"], :name => "by_asset_id"
  add_index "creator_taggings", ["creator_id"], :name => "by_creator_id"

  create_table "creators", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assets_count", :default => 0, :null => false
  end

  add_index "creators", ["name", "user_id"], :name => "by_name", :unique => true

  create_table "downloads", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.string   "status"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "emails", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :default => 0, :null => false
  end

  create_table "forums", :force => true do |t|
    t.integer  "topics_count", :default => 0, :null => false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "list_id",                         :null => false
    t.integer  "position",     :default => 0,     :null => false
    t.boolean  "completed",    :default => false, :null => false
    t.datetime "completed_at"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "resume_id",   :null => false
    t.date     "start_date",  :null => false
    t.date     "end_date"
    t.string   "company",     :null => false
    t.string   "location",    :null => false
    t.string   "title",       :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.integer  "resume_id",                  :null => false
    t.integer  "level_id"
    t.integer  "position",   :default => 0,  :null => false
    t.string   "name",       :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", :force => true do |t|
    t.string  "name",                 :null => false
    t.integer "value", :default => 0, :null => false
  end

  create_table "lists", :force => true do |t|
    t.integer  "user_id",                                   :null => false
    t.boolean  "public",                 :default => false, :null => false
    t.boolean  "hide",                   :default => false
    t.integer  "items_count",            :default => 0,     :null => false
    t.integer  "incomplete_items_count", :default => 0
    t.integer  "complete_items_count",   :default => 0
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_taggings", :force => true do |t|
    t.integer "asset_id"
    t.integer "location_id"
  end

  add_index "location_taggings", ["asset_id"], :name => "by_asset_id"
  add_index "location_taggings", ["location_id"], :name => "by_location_id"

  create_table "locations", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assets_count", :default => 0, :null => false
  end

  add_index "locations", ["name", "user_id"], :name => "by_name", :unique => true

  create_table "magnets", :force => true do |t|
    t.string   "word",       :default => ""
    t.integer  "top",        :default => 0,  :null => false
    t.integer  "left",       :default => 0,  :null => false
    t.integer  "board_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :default => 0
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id",                       :null => false
    t.integer  "recipient_id",                    :null => false
    t.boolean  "read",         :default => false, :null => false
    t.string   "subject",                         :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "hide",       :default => false
    t.boolean  "textilize",  :default => false
    t.boolean  "public",     :default => false, :null => false
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_photoables_photos", :force => true do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "old_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "file"
    t.text     "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "position",   :default => 0, :null => false
    t.string   "path"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["path"], :name => "by_path", :unique => true
  add_index "pages", ["position"], :name => "index_pages_on_position"

  create_table "photoables_photos", :force => true do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "stop_id"
    t.integer  "position",       :default => 0, :null => false
    t.string   "file"
    t.text     "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "comments_count", :default => 0, :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id",    :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publications", :force => true do |t|
    t.integer  "resume_id",                   :null => false
    t.integer  "position",     :default => 0, :null => false
    t.string   "contribution",                :null => false
    t.string   "name",                        :null => false
    t.string   "title",                       :null => false
    t.string   "url"
    t.date     "date",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resumes", :force => true do |t|
    t.integer  "user_id",                               :null => false
    t.boolean  "public",             :default => false, :null => false
    t.boolean  "hide",               :default => false
    t.string   "title"
    t.text     "objective"
    t.text     "summary"
    t.text     "other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "skills_count",       :default => 0,     :null => false
    t.integer  "jobs_count",         :default => 0,     :null => false
    t.integer  "schools_count",      :default => 0,     :null => false
    t.integer  "affiliations_count", :default => 0,     :null => false
    t.integer  "languages_count",    :default => 0,     :null => false
    t.integer  "publications_count", :default => 0,     :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "by_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.integer  "resume_id",   :null => false
    t.date     "start_date",  :null => false
    t.date     "end_date"
    t.string   "name",        :null => false
    t.string   "location",    :null => false
    t.string   "degree"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.integer  "resume_id",                  :null => false
    t.integer  "level_id"
    t.integer  "position",   :default => 0,  :null => false
    t.string   "name",       :default => ""
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stops", :force => true do |t|
    t.integer  "trip_id"
    t.integer  "position",       :default => 0, :null => false
    t.float    "lat"
    t.float    "lng"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :default => 0, :null => false
    t.integer  "images_count",   :default => 0, :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], :name => "by_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "by_taggable"

  create_table "tags", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "taggables_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name", "user_id"], :name => "by_name", :unique => true

  create_table "tic_tac_toes", :force => true do |t|
    t.integer  "player_1_id", :null => false
    t.integer  "player_2_id", :null => false
    t.integer  "turn_id"
    t.integer  "winner_id"
    t.integer  "square_0_id"
    t.integer  "square_1_id"
    t.integer  "square_2_id"
    t.integer  "square_3_id"
    t.integer  "square_4_id"
    t.integer  "square_5_id"
    t.integer  "square_6_id"
    t.integer  "square_7_id"
    t.integer  "square_8_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id",                   :null => false
    t.integer  "user_id",                    :null => false
    t.integer  "posts_count", :default => 0, :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "public",      :default => true,  :null => false
    t.boolean  "hide",        :default => false
    t.integer  "stops_count", :default => 0,     :null => false
    t.string   "title"
    t.float    "lat",         :default => 39.0
    t.float    "lng",         :default => -95.0
    t.integer  "zoom",        :default => 4
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["user_id"], :name => "index_trips_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "activated_email"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
    t.datetime "last_login"
    t.string   "image"
    t.integer  "trips_count",                             :default => 0,    :null => false
    t.integer  "comments_count",                          :default => 0,    :null => false
    t.integer  "boards_count",                            :default => 0,    :null => false
    t.integer  "blogs_count",                             :default => 0,    :null => false
    t.integer  "lists_count",                             :default => 0,    :null => false
    t.integer  "resumes_count",                           :default => 0,    :null => false
    t.integer  "topics_count",                            :default => 0,    :null => false
    t.integer  "posts_count",                             :default => 0,    :null => false
    t.integer  "notes_count",                             :default => 0
    t.integer  "photos_count",                            :default => 0
    t.integer  "link_sets_count",                         :default => 0
    t.integer  "assets_count",                            :default => 0,    :null => false
    t.integer  "downloads_count",                         :default => 0,    :null => false
  end

  add_index "users", ["email"], :name => "by_email", :unique => true
  add_index "users", ["login"], :name => "by_login", :unique => true

end
