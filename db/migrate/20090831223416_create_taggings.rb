class CreateTaggings < ActiveRecord::Migration
	def self.up
		create_table :taggings do |t|
			t.references :taggable, :polymorphic => true
			t.references :tag
			t.timestamps
		end
		add_index :taggings, [:taggable_id,:taggable_type], :name => 'by_taggable'
		add_index :taggings, :tag_id, :name => 'by_tag_id'
	end

	def self.down
		drop_table :taggings
	end
end
