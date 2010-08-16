require File.dirname(__FILE__) + '/../test_helper'

class StopsControllerTest < ActionController::TestCase
	add_core_tests :stop, :only => [ :confirm_destroy ]
	add_commentability_tests
	add_photoability_tests
	add_orderability_tests :trip, :stops, true

	test "should NOT have create route" do
		assert_raise(ActionController::RoutingError){ post :create, :id => 1, :stop => {} }
	end

	test "should NOT have index route" do
		assert_raise(ActionController::RoutingError){ get :index }
	end


	test "should NOT get new without login" do
		get :new, :trip_id => Factory(:trip).id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get new without owner login" do
		login_as active_user
		get :new, :trip_id => Factory(:trip).id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get new with owner login" do
		trip = Factory(:trip)
		login_as trip.user
		get :new, :trip_id => trip.id
		assert_equal assigns(:stop).trip, assigns(:trip)
		assert_equal assigns(:stop).user, trip.user
		assert_response :success
		assert_template 'new'
	end

	test "should get new with owner login and existing stops" do
		trip = trip_with_stops
		login_as trip.user
		get :new, :trip_id => trip.id
		assert_equal assigns(:stop).trip, assigns(:trip)
		assert_equal assigns(:stop).user, trip.user
		assert_response :success
		assert_template 'new'
	end

	test "should get new with admin login" do
		trip = Factory(:trip)
		login_as admin_user
		get :new, :trip_id => trip.id
		assert_equal assigns(:stop).trip, assigns(:trip)
		assert_equal assigns(:stop).user, trip.user
		assert_response :success
		assert_template 'new'
	end


	test "should NOT get edit without login" do
		login_as nil
		get :edit, :id => Factory(:stop).id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without owner login" do
		login_as active_user
		get :edit, :id => Factory(:stop).id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		stop = Factory(:stop)
		login_as stop.user
		get :edit, :id => stop.id
		assert_not_nil assigns(:stop)
		assert_response :success
		assert_template 'edit'
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :id => Factory(:stop).id
		assert_not_nil assigns(:stop)
		assert_response :success
		assert_template 'edit'
	end


	test "should NOT update stop without login" do
		stop = Factory(:stop)
		put :update, :id => stop.id, :stop => Factory.attributes_for(:stop)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update stop without owner login" do
		stop = Factory(:stop)
		login_as active_user
		put :update, :id => stop.id, :stop => Factory.attributes_for(:stop)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update stop with update_attributes failure" do
		Stop.any_instance.stubs(:update_attributes).returns(false)
		stop = Factory(:stop)
		login_as stop.user
		put :update, :id => stop.id, :stop => Factory.attributes_for(:stop)
		assert_response :success
		assert_not_nil flash[:error]
		assert_template 'edit'
	end

	test "should update stop with owner login and photos" do
		stop = stop_with_photos(Factory(:trip))
		photos = {}
		stop.photos.each do |photo|
			photos[photo.id.to_s] = { 'caption' => 'New Caption' }
		end
		login_as stop.user
		put :update, :id => stop.id, :stop => Factory.attributes_for(:stop),
			:photo => photos
		assert_equal assigns(:stop).photos.first.reload.caption, 'New Caption'
		assert_redirected_to stop_path(assigns(:stop))
		stop.photos.destroy_all #	ensure that the files are removed
	end

	test "should update stop with owner login" do
		stop = Factory(:stop)
		login_as stop.user
		put :update, :id => stop.id, :stop => Factory.attributes_for(:stop)
		assert_redirected_to stop_path(assigns(:stop))
	end

	test "should update stop with admin login" do
		stop = Factory(:stop)
		login_as admin_user
		put :update, :id => stop.id, :stop => Factory.attributes_for(:stop)
		assert_redirected_to stop_path(assigns(:stop))
	end


	test "should show stop on public trip without login" do
		login_as nil
		get :show, :id => Factory(:public_stop).id
		assert_not_nil assigns(:stop)
		assert_not_nil assigns(:trip)
		assert_response :success
		assert_template 'show'
		assert_select 'title', assigns(:stop).title
	end

	test "should NOT show stop on private trip without login" do
		login_as nil
		get :show, :id => Factory(:private_stop).id
		assert_not_nil assigns(:stop)
		assert_not_nil assigns(:trip)
		assert_redirected_to root_path
	end

	test "should NOT show stop on private trip without owner login" do
		login_as active_user
		get :show, :id => Factory(:private_stop).id
		assert_not_nil assigns(:stop)
		assert_not_nil assigns(:trip)
		assert_redirected_to root_path
	end

	test "should show stop on private trip with owner login" do
		stop = Factory(:private_stop)
		login_as stop.user
		get :show, :id => stop.id
		assert_not_nil assigns(:stop)
		assert_not_nil assigns(:trip)
		assert_response :success
		assert_template 'show'
	end

	test "should show stop on private trip with admin login" do
		login_as admin_user
		get :show, :id => Factory(:private_stop).id
		assert_not_nil assigns(:stop)
		assert_not_nil assigns(:trip)
		assert_response :success
		assert_template 'show'
	end


	test "should NOT update stop latlng without login" do
		stop = Factory(:stop)
		put :update_latlng, :id => stop.id, :lat => 50, :lng => 50
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update stop latlng without owner login" do
		stop = Factory(:stop)
		login_as active_user
		put :update_latlng, :id => stop.id, :lat => 50, :lng => 50
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should update stop latlng with owner login" do
		stop = Factory(:stop)
		login_as stop.user
		wants :js
		put :update_latlng, :id => stop.id, :lat => 50, :lng => 50
		assert_response :success
		assert_select_rjs :highlight, "#table_stop_#{assigns(:stop).id}"
	end

	test "should update stop latlng with admin login" do
		stop = Factory(:stop)
		login_as admin_user
		wants :js
		put :update_latlng, :id => stop.id, :lat => 50, :lng => 50
		assert_response :success
		assert_select_rjs :highlight, "#table_stop_#{assigns(:stop).id}"
	end


	test "should NOT destroy stop without login" do
		stop = Factory(:stop)
		assert_no_difference('Stop.count') do
			delete :destroy, :id => stop.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy stop without owner login" do
		stop = Factory(:stop)
		login_as active_user
		assert_no_difference('Stop.count') do
			delete :destroy, :id => stop.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy stop with owner login" do
		stop = Factory(:stop)
		login_as stop.user
		wants :html
		assert_difference('Stop.count', -1) do
			delete :destroy, :id => stop.id
		end
		assert_redirected_to trip_url(assigns(:trip))
	end

	test "should destroy stop with admin login" do
		stop = Factory(:stop)
		login_as admin_user
		wants :html
		assert_difference('Stop.count', -1) do
			delete :destroy, :id => stop.id
		end
		assert_redirected_to trip_url(assigns(:trip))
	end

	test "should destroy stop with owner login js" do
		stop = Factory(:stop)
		login_as stop.user
		wants :js
		assert_difference('Stop.count', -1) do
			delete :destroy, :id => stop.id
		end
		assert_response :success
		assert_select_rjs :remove, "#stop_#{assigns(:stop).id}"
	end

	test "should destroy stop with admin login js" do
		stop = Factory(:stop)
		login_as admin_user
		wants :js
		assert_difference('Stop.count', -1) do
			delete :destroy, :id => stop.id
		end
		assert_response :success
		assert_select_rjs :remove, "#stop_#{assigns(:stop).id}"
	end

end
