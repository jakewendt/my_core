class PdfBuilderWorker < BackgrounDRb::MetaWorker
  set_worker_name :pdf_builder_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
#		puts "PDF Builder worker created."
#		logger.info "PDF Builder worker created."
  end

	def trigger_build(download_id)
		puts "PDF Builder worker trigger_builded for #{download_id}."
#		logger.info "PDF Builder worker trigger_builded."
		Download.find(download_id).start_build
	end
end

