module DownloadsHelper

	def classes_for_download(download)
		classes = ['row']
		classes.push(download.status) if download.status
		classes.join(' ')
	end

end
