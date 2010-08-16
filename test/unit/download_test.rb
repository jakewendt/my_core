require File.dirname(__FILE__) + '/../test_helper'

class DownloadTest < ActiveSupport::TestCase

#	def teardown
#		#	destroy so that files are deleted
#		Download.destroy_all
#	end

	test "should create download" do
		assert_difference( 'Download.count' ) {
		assert_difference( 'BdrbJobQueue.count' ) {
			download = create_download
			assert !download.new_record?, "#{download.errors.full_messages.to_sentence}"
		} }
	end

	test "should require url" do
		assert_no_difference( 'Download.count' ) {
		assert_no_difference( 'BdrbJobQueue.count' ) {
			download = create_download(:url => nil)
			assert download.errors.on(:url)
		} }
	end

	test "should set name on create" do
		download = create_download
		assert_not_nil download.name
	end

#	test "should create download without body" do
#		assert_difference 'Download.count' do
#			download = create_download(:body => nil)
#			assert !download.new_record?, "#{download.errors.full_messages.to_sentence}"
#		end
#	end

	test "should require user" do
		assert_no_difference( 'Download.count' ) {
		assert_no_difference( 'BdrbJobQueue.count' ) {
			download = create_download( {}, false )
			assert download.errors.on(:user_id)
		} }
	end

	test "should create pdf file on start_build" do
		download = Factory(:download)
		download.start_build
		assert download.status == "success"
		assert File.exists?(download.server_file)
		download.destroy
		assert !File.exists?(download.server_file)
	end

	test "should fail to create pdf file on start_build when render_file fails" do
		download = Factory(:download)
		Prawn::Document.any_instance.stubs(:render_file).returns(false)
		download.start_build
		#
		#	poor cleanup will leave previous files behind resulting in the possibility
		#	of the check in the model of thinking that the new file was rendered
		#	causing this next assertion to fail
		#
		assert download.status == "failure"
		assert !File.exists?(download.server_file)
	end

	test "should fail to create pdf file on start_build when render_file raises error" do
		download = Factory(:download)
		#	using render_file, but any exception will cause this
		Prawn::Document.any_instance.stubs(:render_file).raises(StandardError)
		download.start_build
		#
		#	poor cleanup will leave previous files behind resulting in the possibility
		#	of the check in the model of thinking that the new file was rendered
		#	causing this next assertion to fail
		#
		assert download.status == "failure"
		assert !File.exists?(download.server_file)
	end

	test "should delete pdf file on destroy" do
		download = Factory(:download)
		download.start_build
		assert File.exists?(download.server_file)
		download.destroy
		assert !File.exists?(download.server_file)
	end

protected

	def create_download(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:download,options)
		record.save
		record
	end

end
