# This is a generalized version of most of the common tests I've been running
# on things that belong to users.	I tried to make it as generic as possible
# by pulling values from the calling controller class.
# Some of these tests are overridden by the testers that require something
# a little different.
#
# This does not YET work for anything that is nested inside something else.
#
module CoreTest

  def self.included(base)
		base.extend(ClassMethods)
#		base.instance_eval do
#			include InstanceMethods
#		end
  end 
  
  module ClassMethods

    def add_core_tests(model,*args)
			default_actions = [ :new, :create, :edit, :update, :update_js, :show, 
				:destroy, :destroy_js, :index, :confirm_destroy ]
			options = args.extract_options!
			options[:actions] = if options.has_key?(:only)
				options[:only]
			else
				default_actions
			end
			if options.has_key?(:except)
				options[:actions].delete_if{|action| options[:except].include?(action)}
			end

			define_method "test_should_NOT_get_index_without_login" do
				get :index
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end if options[:actions].include?(:index)
		
			define_method "test_should_get_index_with_login" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}")
				obj3 = Factory("private_#{model.to_s}")
				user = obj1.user
				tag = Factory(:tag, :user => user)
				login_as user
				get :index
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 2, assigns(model.to_s.pluralize).length
				assigns(model.to_s.pluralize).each do |obj|
					assert(( obj.user == user ) || obj.public )
				end
				assert_response :success
				assert_template "index"
			end if options[:actions].include?(:index)
		
		
			define_method "test_should_NOT_get_new_without_login" do
				get :new
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end if options[:actions].include?(:new)
		
			define_method "test_should_get_new_with_login" do
				login_as active_user
				get :new
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template "new"
			end if options[:actions].include?(:new)
		
		
			define_method "test_should_NOT_create_without_login" do
				assert_no_difference("#{model.to_s.capitalize}.count") { 
					post :create, { 
						model => Factory.attributes_for(model)
					}
				}
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end if options[:actions].include?(:create)
		
			define_method "test_should_create_with_login" do
				user = active_user
				login_as user
				assert_difference("#{model.to_s.capitalize}.count", 1) { 
					post :create, { 
						model => Factory.attributes_for(model)
					}
				}
				assert_equal assigns(model.to_s).user, user
				assert_redirected_to eval("edit_#{model}_path(" << assigns(model.to_s).to_param << ")")
			end if options[:actions].include?(:create)
		
			define_method "test_should_NOT_create_with_empty_component" do
				user = active_user
				login_as user
				assert_no_difference("#{model.to_s.capitalize}.count") { 
					post :create, { model => {} }
				}
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template 'new'
				assert_not_nil flash[:error]
			end if options[:actions].include?(:create)
		
			define_method "test_should_show_public_without_login" do
				obj = Factory("public_#{model.to_s}")
				get :show, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template "show"
				assert_select 'title', /#{assigns(model.to_s).title}/
			end if options[:actions].include?(:show)
		
			define_method "test_should_NOT_show_private_without_login" do
				obj = Factory("private_#{model.to_s}")
				get :show, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_redirected_to root_path
			end if options[:actions].include?(:show)
		
			define_method "test_should_NOT_show_private_without_owner_login" do
				login_as active_user
				get :show, :id => Factory("private_#{model.to_s}")
				assert_not_nil assigns(model.to_s)
				assert_redirected_to root_path
			end if options[:actions].include?(:show)
		
			define_method "test_should_show_private_with_owner_login" do
				obj = Factory("private_#{model.to_s}")
				login_as obj.user
				get :show, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template "show"
				assert_select 'title', /#{assigns(model.to_s).title}/
			end if options[:actions].include?(:show)
		
			define_method "test_should_show_private_with_admin_login" do
				login_as admin_user
				get :show, :id => Factory("private_#{model.to_s}")
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template "show"
				assert_select 'title', /#{assigns(model.to_s).title}/
			end if options[:actions].include?(:show)
		
		
			define_method "test_should_NOT_get_edit_without_login" do
				get :edit, :id => Factory("public_#{model.to_s}")
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end if options[:actions].include?(:edit)
		
			define_method "test_should_NOT_get_edit_without_owner_login" do
				obj = Factory("public_#{model.to_s}")
				login_as active_user
				get :edit, :id => obj.id
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if options[:actions].include?(:edit)
		
			define_method "test_should_get_edit_with_owner_login" do
				obj = Factory("public_#{model.to_s}")
				login_as obj.user
				get :edit, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template "edit"
			end if options[:actions].include?(:edit)
		
			define_method "test_should_get_edit_with_admin_login" do
				obj = Factory("public_#{model.to_s}")
				login_as admin_user
				get :edit, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_template "edit"
			end if options[:actions].include?(:edit)
		
		
		
			define_method "test_should_NOT_update_without_login" do
				obj = Factory(model)
				wants :html
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end if options[:actions].include?(:update)

			define_method "test_should_NOT_update_js_without_login" do
				obj = Factory(model)
				wants :js
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_response :success
			end if options[:actions].include?(:update_js)
		
			define_method "test_should_NOT_update_without_owner_login" do
				obj = Factory(model)
				login_as active_user
				wants :html
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_not_nil flash[:error]
				assert_equal assigns(model.to_s).user, obj.user
				assert_redirected_to root_path
			end if options[:actions].include?(:update)

			define_method "test_should_NOT_update_js_without_owner_login" do
				obj = Factory(model)
				login_as active_user
				wants :js
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_equal assigns(model.to_s).user, obj.user
				assert_response :success
			end if options[:actions].include?(:update_js)
		
			define_method "test_should_update_with_owner_login" do
				obj = Factory(model)
				login_as obj.user
				wants :html
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_equal assigns(model.to_s).user, obj.user
				assert_redirected_to eval("#{model}_path(" << assigns(model.to_s).to_param << ")")
			end if options[:actions].include?(:update)
		
#	 don't know why I do this as I never actually update via javascript
#	actually, I think that board used to have a 'save and continue to edit' I think
			define_method "test_should_update_js_with_owner_login" do
				obj = Factory(model)
				login_as obj.user
				wants :js
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_equal assigns(model.to_s).user, obj.user
				assert_response :success
				assert_select_rjs :highlight, "#content"
			end if options[:actions].include?(:update_js)
		
			define_method "test_should_NOT_update_invalid_with_owner_login" do
				obj = Factory(model)
				login_as obj.user
				wants :html
				put :update, :id => obj.id, model => Factory.attributes_for(model).merge(:title => nil)
				assert_equal assigns(model.to_s).user, obj.user
				assert_response :success
				assert_template 'edit'
			end if options[:actions].include?(:update)
		
			define_method "test_should_update_with_admin_login" do
				obj = Factory(model)
				login_as admin_user
				wants :html
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_equal assigns(model.to_s).user, obj.user
				assert_redirected_to eval("#{model}_path(" << assigns(model.to_s).to_param << ")")
			end if options[:actions].include?(:update)
		
#	 don't know why I do this as I never actually update via javascript
#	actually, I think that board used to have a 'save and continue to edit' I think
			define_method "test_should_update_js_with_admin_login" do
				obj = Factory(model)
				login_as admin_user
				wants :js
				put :update, :id => obj.id, model => Factory.attributes_for(model)
				assert_equal assigns(model.to_s).user, obj.user
				assert_response :success
				assert_select_rjs :highlight, "#content"
			end if options[:actions].include?(:update_js)
		
		
		
		
			define_method "test_should_NOT_destroy_without_login" do
				obj = Factory("public_#{model.to_s}")
				wants :html
				assert_no_difference("#{model.to_s.capitalize}.count") do
					delete :destroy, :id => obj.id
				end
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end if options[:actions].include?(:destroy)

			define_method "test_should_NOT_destroy_js_without_login" do
				obj = Factory("public_#{model.to_s}")
				wants :js
				assert_no_difference("#{model.to_s.capitalize}.count") do
					delete :destroy, :id => obj.id
				end
				assert_response :success
			end if options[:actions].include?(:destroy_js)
		
			define_method "test_should_NOT_destroy_without_owner_login" do
				obj = Factory("public_#{model.to_s}")
				login_as active_user
				wants :html
				assert_no_difference("#{model.to_s.capitalize}.count") do
					delete :destroy, :id => obj.id
				end
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end if options[:actions].include?(:destroy)

			define_method "test_should_NOT_destroy_js_without_owner_login" do
				obj = Factory("public_#{model.to_s}")
				login_as active_user
				wants :js
				assert_no_difference("#{model.to_s.capitalize}.count") do
					delete :destroy, :id => obj.id
				end
				assert_response :success
			end if options[:actions].include?(:destroy_js)
		
			define_method "test_should_destroy_with_owner_login" do
				obj = Factory("public_#{model.to_s}")
				login_as obj.user
				wants :html
					assert_difference("#{model.to_s.capitalize}.count", -1) do
					delete :destroy, :id => obj.id
				end
				assert_not_nil assigns(model.to_s)
				assert_redirected_to eval("#{model.to_s.pluralize}_path")
			end if options[:actions].include?(:destroy)
		
			define_method "test_should_destroy_with_owner_login_js" do
				obj = Factory("public_#{model.to_s}")
				login_as obj.user
				wants :js
				assert_difference("#{model.to_s.capitalize}.count", -1) do
					delete :destroy, :id => obj.id
				end
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_select_rjs :remove, "##{model.to_s}_#{assigns(model).id}"
#				assert_select_rjs :replace_html, "##{model.to_s.pluralize}_count"
			end if options[:actions].include?(:destroy_js)
		
			define_method "test_should_destroy_with_admin_login" do
				obj = Factory("public_#{model.to_s}")
				login_as admin_user
				wants :html
				assert_difference("#{model.to_s.capitalize}.count", -1) do
					delete :destroy, :id => obj.id
				end
				assert_not_nil assigns(model.to_s)
				assert_redirected_to eval("#{model.to_s.pluralize}_path")
			end if options[:actions].include?(:destroy)
		
			define_method "test_should_destroy_with_admin_login_js" do
				obj = Factory("public_#{model.to_s}")
				login_as admin_user
				wants :js
				assert_difference("#{model.to_s.capitalize}.count", -1) do
					delete :destroy, :id => obj.id
				end
				assert_not_nil assigns(model.to_s)
				assert_response :success
				assert_select_rjs :remove, "##{model.to_s}_#{assigns(model).id}"
#				assert_select_rjs :replace_html, "##{model.to_s.pluralize}_count"
			end if options[:actions].include?(:destroy_js)

			test "should NOT confirm destroy without login" do
				obj = Factory(model)
				get :confirm_destroy, :id => obj.id
				assert_redirected_to login_path
			end if options[:actions].include?(:confirm_destroy)

			test "should NOT confirm destroy without owner login" do
				obj = Factory(model)
				login_as active_user
				get :confirm_destroy, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_redirected_to root_path
			end if options[:actions].include?(:confirm_destroy)

			test "should confirm destroy with owner login" do
				obj = Factory(model)
				login_as obj.user
				get :confirm_destroy, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_response :success
			end if options[:actions].include?(:confirm_destroy)

			test "should confirm destroy with admin login" do
				obj = Factory(model)
				login_as admin_user
				get :confirm_destroy, :id => obj.id
				assert_not_nil assigns(model.to_s)
				assert_response :success
			end if options[:actions].include?(:confirm_destroy)

		end

	end	#	 module ClassMethods
end	#	 module CoreTest
#Test::Unit::TestCase.send(:include,CoreTest)
ActiveSupport::TestCase.send(:include,CoreTest)
