# ONLY FOR RUBY 1.9.x -*- encoding : utf-8 -*-
class CreateHistoryEntries < ActiveRecord::Migration
  def self.up
    create_table :history_entries do |t|
      t.integer :entity_id
      t.string :entity_type
      t.text :modifications
      t.integer :modified_by_id
      t.timestamps
    end
    add_index :history_entries, [:entity_type, :entity_id], :unique => false
  end

  def self.down
    remove_index :history_entries, [:entity_type, :entity_id]
    drop_table :history_entries
  end
end
