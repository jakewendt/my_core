require 'tempfile'
require 'net/http'
require 'fileutils'

module Html
	module Test
		class Validator
			#	verbose = true shows "validating ..."
			#	verbose = false shows NOTHING
			@@verbose = true
			cattr_accessor :verbose

			@@tidy_ignore_list = []
			cattr_accessor :tidy_ignore_list

			# For local validation you might change this to http://localhost/validator/htdocs/check
			DEFAULT_W3C_URL = "http://validator.w3.org/check"
			@@w3c_url = DEFAULT_W3C_URL
			cattr_accessor :w3c_url
			
			# Whether the W3C validator should show the HTML document being validated in
			# its response. Set to 0 to disable.
			@@w3c_show_source = "1"
			cattr_accessor :w3c_show_source

			DEFAULT_DTD = File.join(File.dirname(__FILE__), 'DTD', 'xhtml1-strict.dtd')

			# Path to DTD file that the xmllint validator uses
			def self.dtd(document)
				DEFAULT_DTD
			end
			
			# Validate an HTML document string using tidy.
			# Code excerpted from the rails_tidy plugin
			def self.tidy_errors(body)
				tidy = RailsTidy.tidy_factory
				tidy.clean(body)
				errors = tidy.errors.empty? ? nil :
					tidy.errors.delete_if { |e| tidy_ignore_list.select { |p| e =~ p }.size > 0 }.join("\n")
				tidy.release
				errors.blank? ? nil : errors
			end

			# Validate an HTML document string by going to the online W3C validator.
			# Credit for the original code goes to Scott Baron (htonl)
			def self.w3c_errors(body)
				response = Net::HTTP.post_form(URI.parse(w3c_url),
															{'ss'=>w3c_show_source, 'fragment'=>body})
				status = response['x-w3c-validator-status']
				if status != 'Valid'
					# Reference in the stylesheets
					response.body.sub!(%r{@import "./base.css"}, %Q{@import "#{File.dirname(w3c_url)}/base.css"})
					response_file = find_unique_path(File.join(tmp_dir, "w3c_response.html"))
					open(response_file, "w") { |f| f.puts(response.body) }
					"W3C status #{status}. Response from W3C was written to the file #{response_file}"
				else
					nil
				end
			end

			# Validate an HTML document string using the xmllint command line validator tool.
			# Returns nil if validation passes and an error message otherwise.
			# Original code taken from the book "Enterprise Integration with Ruby"
			def self.xmllint_errors(body)
				error_file = create_tmp_file("xmllint_error")
				doc_file = command = nil
				if dtd(body) =~ /^doctype$/i
					# Use the DOCTYPE declaration
					doc_file = create_tmp_file("xmllint", body)
					command = "xmllint --noout --valid #{doc_file} &> #{error_file}"
				else
					# Override the DOCTYPE declaration
					doc_file = create_tmp_file("xmllint", body.sub(/<!DOCTYPE[^>]+>/m, ""))
					command = "xmllint --noout --dtdvalid #{dtd(body)} #{doc_file} &> #{error_file}"
				end
				system(command)
				status = $?.exitstatus
				if status == 0
					return nil
				else
					failure_doc = File.join(tmp_dir, "xmllint_last_response.html")
					FileUtils.cp doc_file, failure_doc
					return ("command='#{command}'. HTML document at '#{failure_doc}'. " +
						IO.read(error_file))
				end
			end
			
			private
			def self.find_unique_path(path)
				filename = File.basename(path)
				ext = File.extname(filename)
				size_no_ext = filename.size - ext.size
				filename_no_ext = filename[0, size_no_ext]
				counter = 2
				while File.exists?(path)
					new_filename = [filename_no_ext, "-", counter, ext].join
					path = File.join(File.dirname(path), new_filename)
					counter += 1
				end
				path
			end
			
			def self.create_tmp_file(name, contents = "")
				tmp_file = Tempfile.new(name)
				tmp_file.puts(contents)
				tmp_file.close
				tmp_file.path
			end
			
			def self.tmp_dir
				Dir::tmpdir
			end
		end
	end
end
