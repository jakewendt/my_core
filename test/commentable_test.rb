module CommentableTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
		def add_commentability_tests

			define_method "create_comment" do |commentable_id|
				post :create_comment, 
					:id => commentable_id,
					:comment => { 
						:body => "My comment" 
					}
			end

			test "should NOT create comment without login" do
				@commentable = Factory(@controller.controller_name.classify.downcase)
				assert_equal 0, @commentable.comments.count
				assert_no_difference('@commentable.comments.count') { create_comment(@commentable.id) }
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end

			test "should NOT create comment with save failure" do
				Comment.any_instance.stubs(:save).returns(false)
				login_as active_user
				@commentable = Factory(@controller.controller_name.classify.downcase)
				assert_equal 0, @commentable.comments.count
				assert_no_difference('@commentable.comments.count') { create_comment(@commentable.id) }
				assert_equal assigns(:comment).commentable, @commentable
				assert_response :success		# AJAX creation
				assert_not_nil flash[:error]
				assert @response.body.blank?
			end

			test "should create comment with login" do
				login_as active_user
				@commentable = Factory(@controller.controller_name.classify.downcase)
				assert_equal 0, @commentable.comments.count
				assert_difference('@commentable.comments.count',1) { create_comment(@commentable.id) }
				assert_equal assigns(:comment).commentable, @commentable
				assert_response :success		# AJAX creation
				assert_select_rjs
			end

		end
	end
end
Test::Unit::TestCase.send(:include,CommentableTest)
