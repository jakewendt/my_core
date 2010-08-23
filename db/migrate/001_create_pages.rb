class CreatePages < ActiveRecord::Migration
	def self.up
		create_table :pages do |t|
			t.integer :position, :null => false, :default => 0
			t.string  :path
			t.string  :title
			t.text    :body
			t.timestamps
		end
		add_index :pages, :position
#	before/after now requires a page#path
#		Page.create({
#			:position => 1,
#			:title => "Home",
#			:body	=> "This would be the perfect place to put your 'home page' info."
#		})
	end

	def self.down
		drop_table :pages
	end
end
