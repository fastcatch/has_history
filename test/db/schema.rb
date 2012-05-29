ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.column "name", :string
    t.column "email", :string
  end
  
  create_table "posts", :force => true do |t|
    t.column "title", :string
    t.column "body", :text
    t.column "user_id", :integer
  end

  create_table "history_entries", :force => true do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.text     "modifications"
    t.integer  "modified_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end