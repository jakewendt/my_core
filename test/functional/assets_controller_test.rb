require File.dirname(__FILE__) + '/../test_helper'
#require 'hash_extension'

class AssetsControllerTest < ActionController::TestCase

#	add_core_tests( :asset, { :except => [ :update_js, :destroy_js ] } )
	add_core_tests( :asset, { :except => [ :update_js ] } )
	add_pdf_downloadability_tests 'Factory(:asset)', %w(show index)
	add_txt_downloadability_tests 'Factory(:asset)', %w(show index)

	# override because redirects to show and not edit
	#	because the method already exists, test "" do won't work
	def test_should_create_with_login
		user = active_user
		login_as user
		assert_difference('Asset.count', 1) { create }
		assert_equal assigns(:asset).user, user
		assert_redirected_to asset_path(assigns(:asset))
	end


	test "should NOT search without login" do
		asset1 = Factory(:asset)
		asset2 = Factory(:asset)
		get :index, :title => ""
		assert_redirected_to login_path
	end

	test "should search no params" do
		asset1 = Factory(:asset)
		asset2 = Factory(:asset)
		login_as asset1.user
		get :index, :title => ""
		assert_response :success
		assert_template "index"
		assert_not_nil assigns(:assets)
		assert_equal assigns(:assets).length, asset1.user.reload.assets.size
		assert !assigns(:assets).include?(asset2)
	end

	test "should search by title" do
		asset1 = Factory(:asset)
		asset2 = Factory(:asset)
		login_as asset1.user
		get :index, :title => ""
		assert_response :success
		assert_template "index"
		assert_not_nil assigns(:assets)
		assert_equal assigns(:assets).length, asset1.user.reload.assets.size
		assert !assigns(:assets).include?(asset2)
	end

	%w( category creator location ).each do |model|
		test "should search by #{model} as string" do
			asset1 = Factory(:asset,{ "#{model}_names" => "tag1"})
			asset2 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2"})
			asset3 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2,tag3"})
			login_as asset1.user
			get :index, model => 'tag2'
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 2, assigns(:assets).length
			assert !assigns(:assets).include?(asset1)
		end
	
		test "should search by not #{model} as string" do
			asset1 = Factory(:asset,{ "#{model}_names" => "tag1"})
			asset2 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2"})
			asset3 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2,tag3"})
			login_as asset1.user
			get :index, model => '!tag3'
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 2, assigns(:assets).length
			assert !assigns(:assets).include?(asset3)
		end
		test "should search by #{model} as array" do
			asset1 = Factory(:asset,{ "#{model}_names" => "tag1"})
			asset2 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2"})
			asset3 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2,tag3"})
			login_as asset1.user
			get :index, model => ['tag2']
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 2, assigns(:assets).length
			assert !assigns(:assets).include?(asset1)
		end
	
		test "should search by not #{model} as array" do
			asset1 = Factory(:asset,{ "#{model}_names" => "tag1"})
			asset2 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2"})
			asset3 = Factory(:asset,{:user => asset1.user, "#{model}_names" => "tag1,tag2,tag3"})
			login_as asset1.user
			get :index, model => ['!tag3']
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 2, assigns(:assets).length
			assert !assigns(:assets).include?(asset3)
		end
	end

	%w( acquired used sold ).each do |filter|
		test "should search by #{filter} as string" do
			asset1 = Factory(:asset)
			asset2 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			asset3 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			login_as asset1.user
	
			get :index, :filter => filter
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 2, assigns(:assets).length
			assert !assigns(:assets).include?(asset1)
		end
		test "should search by not #{filter} as string" do
			asset1 = Factory(:asset)
			asset2 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			asset3 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			login_as asset1.user
	
			get :index, :filter => "!#{filter}"
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 1, assigns(:assets).length
			assert !assigns(:assets).include?(asset2)
			assert !assigns(:assets).include?(asset3)
		end
		test "should search by #{filter} as array" do
			asset1 = Factory(:asset)
			asset2 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			asset3 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			login_as asset1.user
	
			get :index, :filter => [filter]
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 2, assigns(:assets).length
			assert !assigns(:assets).include?(asset1)
		end
		test "should search by not #{filter} as array" do
			asset1 = Factory(:asset)
			asset2 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			asset3 = Factory(:asset,{ :user => asset1.user, "#{filter}_on" => Time.now })
			login_as asset1.user
	
			get :index, :filter => ["!#{filter}"]
			assert_response :success
			assert_template "index"
			assert_not_nil assigns(:assets)
			assert_equal 1, assigns(:assets).length
			assert !assigns(:assets).include?(asset2)
			assert !assigns(:assets).include?(asset3)
		end
	end




	def test_should_show_public_without_login
		assert true
	end

	def test_should_NOT_show_private_without_login
		assert true
	end

	def test_should_get_index_with_login
		asset1 = Factory("asset")
		asset2 = Factory("asset")
		user = asset1.user
		login_as user
		get :index
		assert_not_nil assigns(:assets)
		assert_equal 1, assigns(:assets).length
		assigns(:assets).each do |asset|
			assert_equal asset.user, user
		end
		assert_response :success
		assert_template "index"
	end


	test "should NOT get batch new without login" do
		get :batch_new
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get batch new with login" do
		login_as active_user
		get :batch_new
		assert_response :success
		assert_template 'batch_new'
	end

	test "should NOT get batch create without login" do
		assert_no_difference( 'Asset.count' ) do
			post :batch_create, :asset => Factory.attributes_for(:asset), :titles => "alpha\nbeta\ngamma"
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get batch create with login" do
		login_as active_user
		assert_difference( 'Asset.count', 3 ) do
			post :batch_create, :asset => Factory.attributes_for(:asset), :titles => "alpha\nbeta\ngamma"
		end
		assert_not_nil flash[:notice]
		assert_redirected_to assets_path
	end

	test "should get batch create with login and empty lines" do
		login_as active_user
		assert_difference( 'Asset.count', 3 ) do
			post :batch_create, :asset => Factory.attributes_for(:asset), :titles => "alpha\n\nbeta\ngamma"
		end
		assert_not_nil flash[:notice]
		assert_redirected_to assets_path
	end

	test "should get batch create with login but not create any empty lines" do
		login_as active_user
		assert_no_difference( 'Asset.count' ) do
			post :batch_create, :asset => Factory.attributes_for(:asset), :titles => " \n\n \n"
		end
		assert_not_nil flash[:notice]
		assert_redirected_to assets_path
	end

	test "should fail batch create when save raises an error" do
		login_as active_user
		Asset.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(Asset.new))
		assert_no_difference( 'Asset.count' ) do
			post :batch_create, :asset => Factory.attributes_for(:asset), :titles => "alpha\n\nbeta\ngamma"
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'batch_new'
	end

	test "should create asset with category tags and no duplicates" do
		user = active_user
		login_as user
		assert_difference('CategoryTagging.count', 1) {
		assert_difference('Category.count', 1) {
		assert_difference('Asset.count', 1) {
			create( :asset => Factory.attributes_for(:asset,
				:category_names => "computer, computer" 
			) )
		} } }
		assert_equal assigns(:asset).user, user
		assert_redirected_to asset_path(assigns(:asset))
	end

	test "should NOT stream_edit assets without login" do
		asset1 = Factory(:asset)
		asset2 = Factory(:asset, :user => asset1.user )
		get :stream_edit
		assert_redirected_to login_path
	end

	test "should NOT stream_edit assets without assets" do
		login_as active_user
		get :stream_edit
		assert_redirected_to assets_path
	end

	test "should NOT stream_edit assets without user assets" do
		asset = Factory(:asset)
		login_as active_user
		get :stream_edit
		assert_redirected_to assets_path
	end

	test "should stream_edit assets with login" do
		asset = Factory(:asset)
		assets = (1..3).collect{|i|Factory(:asset,:user => asset.user)}
		login_as asset.user
		get :stream_edit
		assert_response :success
		assert_template 'edit'
		assert !assigns(:asset).is_a?(Array)
		assert_equal assigns(:asset), asset
		assert_not_nil assigns(:ids)
		assert_equal 3, assigns(:ids).length
		assert_equal assets[0].id, assigns(:ids).first
	end

	test "should edit next id after update if ids not blank" do
		asset = Factory(:asset)
		assets = (1..3).collect{|i| Factory(:asset,:user => asset.user) }
		login_as asset.user
		put :update, :id => asset.id, :asset => { :title => "qwerqwer" }, :ids => assets.collect(&:id).join(',')
		assert_response :success
		assert_template 'edit'
		assert !assigns(:asset).is_a?(Array)
		assert_equal assigns(:asset), assets.first
		assert_not_nil assigns(:ids)
		assert_equal 2, assigns(:ids).length
		assert !assigns(:ids).include?(assets.first.id.to_s)
		assert  assigns(:ids).include?(assets.last.id.to_s)
	end

	test "should NOT show asset for sale without login" do
		asset = Factory(:asset, :for_sale => true )
		get :show, :id => asset.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should show asset for sale with login" do
		asset = Factory(:asset, :for_sale => true )
		login_as active_user
		get :show, :id => asset.id
		assert_response :success
		assert_template 'show'
		assert_equal asset, assigns(:asset)
	end

	def create(options={})
		post :create, { 
			:asset => Factory.attributes_for(:asset)
		}.merge(options)
	end

end

