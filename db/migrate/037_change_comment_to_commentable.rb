class ChangeCommentToCommentable < ActiveRecord::Migration
	def self.up
		rename_column :comments, :stop_id, :commentable_id
#		rename_column :comments, :body, :comment
		add_column		:comments, :commentable_type, :string, :limit => 15, :default => "", :null => false

#		add_index		 :comments, [:commentable_id], :name => "fk_comments_commentable"
		add_index		 :comments, [:user_id], :name => "fk_comments_user"

#		Comment.find(:all).each do |comment|
#			comment.commentable_type = "Stop"
#			comment.save
#		end
		Comment.update_all("commentable_type='Stop'")
	end

	def self.down
		rename_column :comments, :commentable_id, :stop_id
#		rename_column :comments, :comment, :body
		remove_column :comments, :commentable_type
		remove_index	:comments, :name => "fk_comments_user"
	end
end
