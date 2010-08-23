module ResumeComponentTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods

		def add_resume_component_functional_tests(component)

			test "should NOT not have index route" do
				assert_raise(ActionController::RoutingError){ get :index, :resume_id => 1 }
			end
		
			test "should NOT not have new route" do
				assert_raise(ActionController::RoutingError){ get :new, :resume_id => 1 }
			end
		
			test "should NOT not have edit route" do
				assert_raise(ActionController::RoutingError){ get :edit, :id => 1 }
			end
		
			test "should NOT not have show route" do
				assert_raise(ActionController::RoutingError){ get :show, :id => 1 }
			end
		
			test "should NOT not have update route" do
				assert_raise(ActionController::RoutingError){ put :update, :id => 1 }
			end

			test "should NOT not have destroy route" do
				assert_raise(ActionController::RoutingError){ delete :destroy, :id => 1 }
			end

			test "should NOT create without login" do
				resume = Factory(:resume)
				login_as nil 
				assert_no_difference("#{component.to_s.capitalize}.count") do
					post :create, :resume_id => resume,
						component => Factory.attributes_for(component)
				end
				assert_nil assigns(component)
				assert_redirected_to login_path
			end 
		
			test "should NOT create without owner login" do
				resume = Factory(:resume)
				login_as active_user
				assert_no_difference("#{component.to_s.capitalize}.count") do
					post :create, :resume_id => resume,
						component => Factory.attributes_for("public_#{component}")
				end
				assert_nil assigns(component)
				assert_redirected_to root_path
			end 
		
			test "should create with owner login" do
				resume = Factory(:resume)
				login_as resume.user
				assert_difference("#{component.to_s.capitalize}.count", 1) do
					post :create, :resume_id => resume,
						component => Factory.attributes_for(component)
				end
				assert_not_nil assigns(component)
				assert_equal assigns(component).resume_id, assigns(:resume).id
				assert_response :success
			end 
		
			test "should NOT create invalid" do
				resume = Factory(:resume)
				component.to_s.capitalize.constantize.any_instance.stubs(:save!).raises(StandardError)
				login_as resume.user
				assert_no_difference("#{component.to_s.capitalize}.count") do
					post :create, :resume_id => resume,
						component => Factory.attributes_for(component)
				end
				assert_not_nil assigns(component)
				assert_equal assigns(component).resume_id, assigns(:resume).id
				assert_response :success
				assert_not_nil flash[:error]
			end 
		
			test "should create with admin login" do
				resume = Factory(:resume)
				login_as admin_user
				assert_difference("#{component.to_s.capitalize}.count", 1) do
					post :create, :resume_id => resume,
						component => Factory.attributes_for(component)
				end
				assert_not_nil assigns(component)
				assert_equal assigns(component).resume_id, assigns(:resume).id
				assert_response :success
			end 

		end

		def add_resume_component_unit_tests(component)

			test "should update resume updated_at on component create" do
				resume = resume_with_components
				before = resume.reload.updated_at
				sleep 1		#	otherwise the new updated_at could be the same as the old
				Factory(component, :resume => resume)
				after = resume.reload.updated_at
				assert_not_equal before, after
			end

			test "should update resume updated_at on component update" do
				resume = resume_with_components
				before = resume.reload.updated_at
				sleep 1		#	otherwise the new updated_at could be the same as the old
				resume.send(component.to_s.pluralize).first.update_attribute(:updated_at, Time.now)
				after = resume.reload.updated_at
				assert_not_equal before, after
			end

			test "should update resume updated_at on component destroy" do
				resume = resume_with_components
				before = resume.reload.updated_at
				sleep 1		#	otherwise the new updated_at could be the same as the old
				resume.send(component.to_s.pluralize).first.destroy
				after = resume.reload.updated_at
				assert_not_equal before, after
			end

		end
	end

end
