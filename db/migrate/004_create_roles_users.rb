class CreateRolesUsers < ActiveRecord::Migration
	def self.up
		create_table :roles_users, :id => false do |t|
			t.integer :role_id, :user_id, :null => false
			t.timestamps		#	why??
		end
#	put these back!
#		add_index :roles_users, :role_id
#		add_index :roles_users, :user_id



#		#Then, add default admin user
#		#Be sure change the password later or in this migration file
#		user = User.new({
#			:login => "admin",
#			:email => "my@jakewendt.com",
#			:password => "admin",
#			:password_confirmation => "admin"
#		})
#		user.roles << Role.find_by_name('administrator')
#		user.save(false)
#		user = User.find_by_login('admin')
#		user.send(:activate!)
	end
 
	def self.down
		drop_table :roles_users
	end
end
