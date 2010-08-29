module PdfDownloadableTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
		def add_pdf_downloadability_tests( factory_function, actions = %w(show show_public index) )

			test "should show pdf with login" do
				obj = eval(factory_function)
				login_as obj.user
				get :show, :id => obj.id, :format => 'pdf'
				assert_not_nil assigns(obj.class.name.downcase.to_sym)
				assert_response :success
				assert_template 'show'
				assert @response.body.include?("Creator (Prawn)")
				assert_not_nil @response.headers['Content-disposition'].match(/inline;.*pdf/)
				#	blogs and trips are created with photos that need destroyed
				obj.photoables_photos.each{|pp|pp.photo.destroy} if obj.respond_to?(:photoables_photos)
			end if actions.include?('show_public')

			test "should show public pdf without login" do
				obj = eval(factory_function)
				get :show, :id => obj.id, :format => 'pdf'
				assert_not_nil assigns(obj.class.name.downcase.to_sym)
				assert_response :success
				assert_template 'show'
				assert @response.body.include?("Creator (Prawn)")
				assert_not_nil @response.headers['Content-disposition'].match(/inline;.*pdf/)
				obj.photoables_photos.each{|pp|pp.photo.destroy} if obj.respond_to?(:photoables_photos)
			end if actions.include?('show_public')

			test "should get index and queue pdf build with login" do
				obj = eval(factory_function)
				login_as obj.user
				assert_difference('Download.count',1) {
				assert_difference('BdrbJobQueue.count',1) {
					get :index, :format => 'pdf'
				} }
				assert_redirected_to assigns(:download)
				assigns(:download).start_build
				assert File.exists?(assigns(:download).server_file)
				assigns(:download).destroy	#	make sure that the file is gone
				assert !File.exists?(assigns(:download).server_file)
				obj.photoables_photos.each{|pp|pp.photo.destroy} if obj.respond_to?(:photoables_photos)
			end if actions.include?('index')

			test "should get index and queue pdf build with login and filters" do
				obj = eval(factory_function)

if obj.respond_to?(:photoables_photos)
	#	remove a photo file to test the prawn pdf.photo
	FileUtils.rm_rf(obj.photoables_photos.first.photo.file)
end

				login_as obj.user
				assert_difference('Download.count',1) {
				assert_difference('BdrbJobQueue.count',1) {
					get :index, :format => 'pdf', :foo => '1', :bar => '2'
				} }
				assert_redirected_to assigns(:download)
				assigns(:download).start_build
				assert File.exists?(assigns(:download).server_file)
				assigns(:download).destroy	#	make sure that the file is gone
				assert !File.exists?(assigns(:download).server_file)
				obj.photoables_photos.each{|pp|pp.photo.destroy} if obj.respond_to?(:photoables_photos)
			end if actions.include?('index')

			test "should get index and NOT queue pdf build with failed save" do
				Download.any_instance.stubs(:save).returns(false)
				obj = eval(factory_function)
				login_as obj.user
				assert_no_difference('Download.count') {
				assert_no_difference('BdrbJobQueue.count') {
					get :index, :format => 'pdf'
				} }
				assert_not_nil flash[:error]
#				assert_redirected_to :controller => obj.class.name.downcase.pluralize
				assert_response :redirect
				obj.photoables_photos.each{|pp|pp.photo.destroy} if obj.respond_to?(:photoables_photos)
			end if actions.include?('index')

		end
	end
end
#Test::Unit::TestCase.send(:include,PdfDownloadableTest)
ActiveSupport::TestCase.send(:include,PdfDownloadableTest)
