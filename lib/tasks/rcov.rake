#
#	This is from Advanced Rails Recipes, page 277
#

#	TODO use the version in simply_helpful and delete this

namespace :test do
	
	desc 'Tracks test coverage with rcov'
	task :coverage do
		rm_f "coverage"
		rm_f "coverage.data"
		
		unless PLATFORM['i386-mswin32']
			rcov = "rcov --sort coverage --rails --aggregate coverage.data " <<
							"--text-summary -Ilib -T " <<
							"-x gems/*,db/migrate/*"
#							"-x gems/*,db/migrate/*,jrails/*/*" <<
#							",html_test/*/*" <<
#							",html_test_extension/*/*" <<
#							",rcov*,smtp_tls," <<
#							"authenticated_system,array_extension" 
#							"authenticated_system,hash_extension,array_extension,nil_class_extension" 
		else
			rcov = "rcov.cmd --sort coverage --rails --aggregate " <<
							"coverage.data --text-summary -Ilib -T"
		end
		
		#	At least ONE subdir to as not to get test/commentable_test.rb and the like
		dirs = Dir.glob("test/*/**/*_test.rb").collect{|f|File.dirname(f)}.uniq
		lastdir = dirs.pop
		dirs.each do |dir|
			system("#{rcov} --no-html #{dir}/*_test.rb")
		end
		system("#{rcov} --html #{lastdir}/*_test.rb") unless lastdir.nil?
		
		unless PLATFORM['i386-mswin32']
#	jruby-1.5.0.RC1 > PLATFORM 
#	 => "java" 
#			system("open coverage/index.html") if PLATFORM['darwin']
			system("open coverage/index.html")
		else
			system("\"C:/Program Files/Mozilla Firefox/firefox.exe\" " +
						 "coverage/index.html")
		end
	end
end
