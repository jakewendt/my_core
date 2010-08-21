require 'fileutils'
class Download < ActiveRecord::Base
	SORTABLE_COLUMNS = %w( URL Status Created_At Updated_At Started_At Completed_At )
	acts_as_ownable
	validates_length_of :name, :minimum => 4, :on => :update
	validates_length_of :url, :minimum => 4

	before_destroy :delete_file
	before_create :set_name_equal_to_url
	after_save :trigger_build

	def set_name_equal_to_url
		uri = URI.parse(self.url)
		path = uri.path.sub(/^\//,'') # remove the leading / if exists
		path.sub!(/\.pdf$/,'')
		self.name = [path,uri.query].drop_blanks!.join('?')
	end

	def trigger_build
		if self.started_at.nil?
			MiddleMan.worker(:pdf_builder_worker).enq_trigger_build(:arg => self.id, :job_key => Time.now.to_s)
		end
	end

	def delete_file
		FileUtils.rm_rf(server_file) if File.exists?(server_file)
	end

	def server_dir
		@server_dir ||= ( RAILS_ENV == 'test' ) ? File.join(RAILS_ROOT, "test/downloads") : File.join(RAILS_ROOT, "downloads")
	end

	def server_file
		FileUtils.mkpath(server_dir) unless File.exists?(server_dir)
		@server_file ||= "#{server_dir}/#{self.id}"
	end

	def local_file
		@local_file ||= "#{self.name}_#{self.completed_at.to_s(:filename)}.pdf"
	end

	def start_build
		self.update_attribute(:started_at, Time.now)

		uri = URI.parse self.url
		#	if no params, uri.query is nil which causes and error in CGI.parse
		#		params = CGI.parse uri.query||""
		#	returns ... {"tags"=>["Personal"]}
		#	but want { "tags" => "personal" } so
		# if you want it done right, do it yourself
		params = (uri.query||"").to_params_hash

		require 'prawn_extension'
		pdf = Prawn::Document.new

#
#	sure would be nice to know the page numbers so could create an better TOC
#

#	need to change 
#	self.user.notes.search()
#	to
#	Note.public_and_mine(self.user).search()
#	also change filter to include user_id link from view (rather than show user profile)
		
		resources = []
		action = uri.path.split('/').drop_blanks![0].split('.')[0]
		if action == 'mystuff'
			resources = %w( notes lists blogs trips )
			pdf.move_down(200)
			pdf.text "Your Stuff by #{self.user.login}", :size => 30, :style => :bold, :align => :center
			pdf.move_down(100)
			pdf.text "Compiled on #{Time.now.to_s(:basic)}", :size => 20, :align => :center
		else
			resources.push(action)
			pdf.move_down(200)
			pdf.text "Your #{action.capitalize} by #{self.user.login}", :size => 30, :style => :bold, :align => :center
			pdf.move_down(100)
			pdf.text "Compiled on #{Time.now.to_s(:basic)}", :size => 20, :align => :center
		end

#		%w( notes lists blogs trips ).each do |resource|
		resources.each do |resource|
			if resource == 'assets'
				pdf.send(resource, self.user.send(resource).search(params))
			else
				pdf.send(resource, resource.singularize.capitalize.constantize.public_and_mine(self.user).search(params))
			end
		end

		pdf.render_file(server_file)
		self.update_attribute(:completed_at, Time.now)
		if File.exists?(server_file)
			self.update_attribute(:status, "success")
			UserMailer.deliver_download_ready(self)
		else
			self.update_attribute(:status, "failure")
		end
	rescue
		self.update_attribute(:status, "failure")
	end

	def self.search(params={})
#		sort_column = untaint_column(params[:sort],[],'created_at')
		sort_column = untaint_column(params[:sort],:default => 'created_at')
		sort_dir = untaint_direction(params[:dir])

		find(:all, :order => "#{sort_column} #{sort_dir}, url ASC")
	end

end
