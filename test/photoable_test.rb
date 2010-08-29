module PhotoableTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
#
# I don't quite understand it, but multiple login_as calls in
# this setting do NOT work properly, even though they do in a
# a normal test controller.
#

		def add_photoability_tests

#			define_method "create_photo" do |photoable|
			define_method "create_photo" do |*args|
				photoable = args[0]
				file = args[1]||'drag.gif'
				post :create_photo, 
					:id => photoable.id,
					:photo => { 
						:file => upload(f(file)),
						:caption => "My caption"
					}
			end

			define_method "attach_photo" do |photoable,photo|
				post :attach_photo,
					:id => photoable.id,
					:photo_id => photo.id
			end

			define_method "detach_photo" do |photoable,photo|
				post :detach_photo,
					:id => photoable.id,
					:photo_id => photo.id
			end

			test "should NOT create photo without login" do
				login_as nil
				photoable = Factory(@controller.controller_name.classify.downcase)
				assert_equal 0, photoable.photos.count
				assert_no_difference('photoable.photos.count') do
					create_photo(photoable)	#	,'drag1.gif')
				end
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end

			test "should NOT create photo without owner login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				login_as active_user
				assert_equal 0, photoable.photos.count
				assert_no_difference('photoable.photos.count') do
					create_photo(photoable)	#	,'drag2.gif')
				end
				assert_not_nil flash[:error]
				assert_redirected_to root_path
			end

			test "should NOT create photo when photoable save fails" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				@controller.controller_name.classify.constantize.any_instance.stubs(:save).returns(false)
				login_as photoable.user
				assert_equal 0, photoable.photos.count
				assert_no_difference('Photo.count') do
					assert_no_difference('PhotoablesPhoto.count') do
						assert_no_difference('photoable.photos.count') do
							create_photo(photoable)	#	,'drag3.gif')
						end
					end
				end
				assert_equal assigns(:photoable), photoable
				assert_response :success		# AJAX creation
				assert_not_nil flash[:error]
				#	uploading the file succeeds and is placed in the temp dir but is not removed
				#	/Users/jake/hostingrails.svn/sites/my/test/tmp/file_column/photo/file/tmp/1253480458.419322.2169
				assert File.exists?(assigns(:photo).file_dir)
				FileUtils.rm_rf(assigns(:photo).file_dir)
				assert !File.exists?(assigns(:photo).file_dir)
			end

			test "should create photo with owner login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				login_as photoable.user
				assert_equal 0, photoable.photos.count
				assert_difference('Photo.count',1) do
					assert_difference('PhotoablesPhoto.count',1) do
						assert_difference('photoable.photos.count',1) do
							create_photo(photoable)	#	,'drag4.gif')
						end
					end
				end
				assert_equal assigns(:photo).photoables[0], photoable	 # FRAGILE
				assert_equal assigns(:photoable), photoable
				assert_response :success		# AJAX creation
				assert File.exists?(assigns(:photo).file)
				assigns(:photo).destroy
				assert !File.exists?(assigns(:photo).file)
			end

			test "should create photo with admin login" do
				login_as admin_user		#	:admin
				photoable = Factory(@controller.controller_name.classify.downcase)
				assert_equal 0, photoable.photos.count
				assert_difference('Photo.count',1) do
					assert_difference('PhotoablesPhoto.count',1) do
						assert_difference('photoable.photos.count',1) do
							create_photo(photoable)	#	,'drag5.gif')
						end
					end
				end
				assert_equal assigns(:photo).photoables[0], photoable	 # FRAGILE
				assert_equal assigns(:photoable), photoable
				assert_response :success		# AJAX creation
				assert File.exists?(assigns(:photo).file)
				assigns(:photo).destroy
				assert !File.exists?(assigns(:photo).file)
			end

			test "should NOT attach photo without login" do
				login_as nil
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				assert_equal 0, photoable.photos.count
				assert_no_difference('PhotoablesPhoto.count') do
					assert_no_difference('photoable.photos.count') do
						attach_photo(photoable,photo)
					end
				end
			end

			test "should NOT attach photo without owner of photo login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo)
				login_as photoable.user
				assert_equal 0, photoable.photos.count
				assert_no_difference('PhotoablesPhoto.count') do
					assert_no_difference('photoable.photos.count') do
						attach_photo(photoable,photo)
					end
				end
			end

			test "should NOT attach photo without owner of photoable login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo)
				login_as photo.user
				assert_equal 0, photoable.photos.count
				assert_no_difference('PhotoablesPhoto.count') do
					assert_no_difference('photoable.photos.count') do
						attach_photo(photoable,photo)
					end
				end
			end

			test "should attach photo with owner login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				login_as photoable.user
				assert_equal 0, photoable.photos.count
				assert_difference('PhotoablesPhoto.count',1) do
					assert_difference('photoable.photos.count',1) do
						attach_photo(photoable,photo)
					end
				end
			end

			test "should attach photo with admin login" do
				login_as admin_user		#	:admin
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				assert_equal 0, photoable.photos.count
				assert_difference('PhotoablesPhoto.count',1) do
					assert_difference('photoable.photos.count',1) do
						attach_photo(photoable,photo)
					end
				end
			end

			test "should NOT detach photo without login" do
				login_as nil
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				photoable.photos << photo
				assert_equal 1, photoable.photos.count
				assert_no_difference('PhotoablesPhoto.count') do
					assert_no_difference('photoable.photos.count') do
						detach_photo(photoable,photo)
					end
				end
			end

			test "should NOT detach photo without owner of photo login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				photoable.photos << photo
				login_as active_user
				assert_equal 1, photoable.photos.count
				assert_no_difference('PhotoablesPhoto.count') do
					assert_no_difference('photoable.photos.count') do
						detach_photo(photoable,photo)
					end
				end
			end

			# should never have been attached, but just in case
			test "should NOT detach photo without owner of photoable login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo)
				photoable.photos << photo
				login_as photoable.user
				assert_equal 1, photoable.photos.count
				assert_no_difference('PhotoablesPhoto.count') do
					assert_no_difference('photoable.photos.count') do
						detach_photo(photoable,photo)
					end
				end
			end

			test "should detach photo with owner login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				photoable.photos << photo
				login_as photoable.user
				assert_equal 1, photoable.photos.count
				assert_difference('PhotoablesPhoto.count',-1) do
					assert_difference('photoable.photos.count',-1) do
						detach_photo(photoable,photo)
					end
				end
			end

			test "should detach photo with admin login" do
				photoable = Factory(@controller.controller_name.classify.downcase)
				photo = Factory(:photo, :user => photoable.user)
				photoable.photos << photo
				login_as admin_user		#	:admin
				assert_equal 1, photoable.photos.count
				assert_difference('PhotoablesPhoto.count',-1) do
					assert_difference('photoable.photos.count',-1) do
						detach_photo(photoable,photo)
					end
				end
			end

		end
	end
end
#Test::Unit::TestCase.send(:include,PhotoableTest)
ActiveSupport::TestCase.send(:include,PhotoableTest)
