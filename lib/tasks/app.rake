namespace :app do

	task :setup => :environment do
		fixtures = []
		fixtures.push('levels')
		fixtures.push('roles')
		ENV['FIXTURES'] = fixtures.join(',')
		puts "Loading fixtures for #{ENV['FIXTURES']}"
#		Rake::Task["db:fixtures:load"].invoke
#		Rake::Task["app:add_users"].invoke
#		ENV['uid'] = '859908'
#		Rake::Task["app:deputize"].invoke
#		ENV['uid'] = '228181'
#		Rake::Task["app:deputize"].reenable	#	<- this is stupid!
#		Rake::Task["app:deputize"].invoke
	end

	desc "Generate MyStuff pdf"
	task :generate_mystuff_pdf => :environment do
		if ENV['user_id'].blank?
			puts "Usage: rake #{$*} user_id=INTEGER"
			exit
		end
		u = User.find(ENV['user_id'])	#	if bad id, an error will be raised
		
		require 'prawn_extension'
		pdf = Prawn::Document.new
		pdf.text("Prawn Rocks")

		pdf.notes(u.notes)
		pdf.lists(u.lists)
		pdf.blogs(u.blogs)
		pdf.trips(u.trips)

		pdf.render_file('prawn.pdf')
	end

	desc "Recalculate the proper assets_count for users"
	task :update_assets_count => :environment do
		#	:counter_cache => ... adds the column to attr_readonly
		#	so we need to remove the attribute from the set, 
		#	which isn't working for me in a rake task. (works in console!?!)
		#	So I'm using direct SQL modifications.
		User.all.each do |u|
			if u.assets_count != u.assets.count
				puts "Updating User:#{u.login} from #{u.assets_count} to #{u.assets.count}"
				a = ActiveRecord::Base.connection.execute(
					"UPDATE users SET assets_count = #{u.assets.count} WHERE id = #{u.id}"
				)
			end
		end
	end

	desc "Recalculate the proper *s_count for categories, creators and locations"
	task :update_asset_tag_counter_caches => :environment do
		#	:counter_cache => ... adds the column to attr_readonly
		#	so we need to remove the attribute from the set, 
		#	which isn't working for me in a rake task. (works in console!?!)
		#	So I'm using direct SQL modifications.
		%w( Category Creator Location ).each do |model|
			model.constantize.all.each do |m|
				if m.assets_count != m.assets.count
					puts "Updating #{model}:#{m.name} from #{m.assets_count} to #{m.assets.count}"
					a = ActiveRecord::Base.connection.execute(
						"UPDATE #{model.constantize.table_name} SET assets_count = #{m.assets.count} WHERE id = #{m.id}"
					)
				end
			end
		end
	end

	desc "Recalculate the proper *complete_items_count for lists"
	task :update_list_counter_caches => :environment do
		#	:counter_cache => ... adds the column to attr_readonly
		#	so we need to remove the attribute from the set, 
		#	which isn't working for me in a rake task. (works in console!?!)
		#	So I'm using direct SQL modifications.
		List.all.each do |list|
			puts "Updating counts for list id #{list.id}"
			puts "Before: Complete:#{list.complete_items_count}, Incomplete:#{list.incomplete_items_count}"
			list.update_attribute(:complete_items_count,	 list.items.complete.count)
			list.update_attribute(:incomplete_items_count, list.items.incomplete.count)
			puts "After: Complete:#{list.complete_items_count}, Incomplete:#{list.incomplete_items_count}"
		end
	end

	desc "Remove duplicate taggings which may have been created before uniqueness added."
	task :remove_duplicate_asset_taggings => :environment do
		puts "Checking for duplicate CategoryTaggings"
		CategoryTagging.find( :all,
			:select => "*, count(*) as count_all",
			:group => "asset_id,category_id",
			:having => "count_all > 1"
		).each do |t|
			puts "Found #{t.inspect}"
			t.destroy
		end
		puts "Checking for duplicate CreatorTaggings"
		CreatorTagging.find( :all,
			:select => "*, count(*) as count_all",
			:group => "asset_id,creator_id",
			:having => "count_all > 1"
		).each do |t|
			puts "Found #{t.inspect}"
			t.destroy
		end
		puts "Checking for duplicate LocationTaggings"
		LocationTagging.find( :all,
			:select => "*, count(*) as count_all",
			:group => "asset_id,location_id",
			:having => "count_all > 1"
		).each do |t|
			puts "Found #{t.inspect}"
			t.destroy
		end
	end

	desc "Set used_on and acquired_on for all Cassettes"
	task :set_used_on_and_acquired_on_for_cassettes => :environment do
		puts "Setting used_on and acquired_on for Cassettes"
		Asset.search(:category => 'Music,Cassette', :filter => "not_acquired,not_used").each do |a|
			puts "Found #{a.title}:acquired:#{a.acquired_on_string}:used:#{a.used_on_string}"
			a.update_attributes(
				:used_on_string => "19800101",
				:acquired_on_string => "19800101"
			)
		end
	end

	desc "Set used_on and acquired_on for all CDs"
	task :set_used_on_and_acquired_on_for_cds => :environment do
		puts "Setting used_on and acquired_on for CDs"
		Asset.search(:category => 'Music,CD', :filter => "not_acquired,not_used").each do |a|
			puts "Found #{a.title}:acquired:#{a.acquired_on_string}:used:#{a.used_on_string}"
			a.update_attributes(
				:used_on_string => "19900101",
				:acquired_on_string => "19900101"
			)
		end
	end

	desc "Set used_on equal to acquired on for CDs"
	task :set_used_on_to_acquired_on => :environment do
		puts "Setting used_on to acquired_on for CDs"
		Asset.search(:category => 'Music,CD', :filter => "acquired,not_used" ).each do |a|
			puts "Found #{a.title}:acquired:#{a.acquired_on_string}:used:#{a.used_on_string}"
			a.update_attribute(:used_on_string, a.acquired_on_string)
		end
	end

	desc "Set acquired_on to used_on for Books for Used For Sale Books with no acquired_on"
	task :set_acquired_on_to_used_on_for_used_for_sale_books => :environment do
		puts "Setting acquired_on to used_on for Used For Sale Books with no acquired_on"
		Asset.search(:category => 'Book,For Sale', :filter => "not_acquired,used" ).each do |a|
			puts "Found #{a.title}:acquired:#{a.acquired_on_string}:used:#{a.used_on_string}"
			a.update_attribute(:acquired_on_string, a.used_on_string)
		end
	end

end
