
Factory.define :user do |f|
	f.sequence(:login) { |n| "foo#{n}" }
	f.password "foobar"
	f.password_confirmation { |u| u.password }
	f.sequence(:email) { |n| "foo#{n}@example.com" }
end

Factory.define :role do |f|
end


Factory.define :blog do |f|
	f.sequence(:title) { |n| "My Blog Title #{n}" }
	f.description "My Blog Description"
	f.association :user
end
Factory.define :private_blog, :parent => :blog do |f|
	f.public false
end
Factory.define :public_blog, :parent => :blog do |f|
	f.public true
end
Factory.define :entry do |f|
	f.sequence(:title) { |n| "My Entry Title #{n}" }
	f.body  "My Entry Body"
	f.association :blog
end
Factory.define :private_entry, :parent => :entry do |f|
	f.association :blog, :factory => :private_blog
end
Factory.define :public_entry, :parent => :entry do |f|
	f.association :blog, :factory => :public_blog
end

Factory.define :board do |f|
	f.sequence(:title) { |n| "My Board Title #{n}" }
	f.association :user
end
Factory.define :private_board, :parent => :board do |f|
	f.public false
end
Factory.define :public_board, :parent => :board do |f|
	f.public true
end
Factory.define :magnet do |f|
	f.association :board
end
Factory.define :private_magnet, :parent => :magnet do |f|
	f.association :board, :factory => :private_board
end
Factory.define :public_magnet, :parent => :magnet do |f|
	f.association :board, :factory => :public_board
end

Factory.define :forum do |f|
	f.sequence(:name) { |n| "My Forum Name #{n}" }
	f.description "My Forum Description"
end
Factory.define :topic do |f|
	f.sequence(:name) { |n| "My Topic Name #{n}" }
	f.association :forum
	f.association :user
end
Factory.define :post do |f|
	f.body "My Forum Topic Post Body"
	f.association :topic
	f.association :user
end


Factory.define :list do |f|
	f.sequence(:title) { |n| "My List Title #{n}" }
	f.description "My List Description"
	f.association :user
end
Factory.define :private_list, :parent => :list do |f|
	f.public false
end
Factory.define :public_list, :parent => :list do |f|
	f.public true
end
Factory.define :item do |f|
	f.content "My Item Content"
	f.association :list
end
Factory.define :completed_item, :parent => :list do |f|
	f.completed true
end
Factory.define :private_item, :parent => :item do |f|
	f.association :list, :factory => :private_list
end
Factory.define :public_item, :parent => :item do |f|
	f.association :list, :factory => :public_list
end

Factory.define :trip do |f|
	f.sequence(:title) { |n| "My Trip Title #{n}" }
	f.description "My Trip Description"
	f.lat   50
	f.lng   50
	f.zoom  8
	f.association :user
end
Factory.define :private_trip, :parent => :trip do |f|
	f.public false
end
Factory.define :public_trip, :parent => :trip do |f|
	f.public true
end
Factory.define :stop do |f|
	f.sequence(:title) { |n| "My Stop Title #{n}" }
	f.lat   50
	f.lng   50
	f.association :trip
end
Factory.define :private_stop, :parent => :stop do |f|
	f.association :trip, :factory => :private_trip
end
Factory.define :public_stop, :parent => :stop do |f|
	f.association :trip, :factory => :public_trip
end


Factory.define :resume do |f|
	f.sequence(:title) { |n| "My Resume Title #{n}" }
	f.objective "Objective"
	f.association :user
end
Factory.define :public_resume, :parent => :resume do |f|
	f.public true
end
Factory.define :private_resume, :parent => :resume do |f|
	f.public false
end
Factory.define :affiliation do |f|
	f.association :resume
	f.start_date_string "January 1, 2000"
	f.organization "Organization"
	f.relationship "Relationship"
end
Factory.define :public_affiliation, :parent => :affiliation do |f|
	f.association :resume, :factory => :public_resume
end
Factory.define :job do |f|
	f.association :resume
	f.sequence(:title) { |n| "My Job Title #{n}" }
	f.company "Company"
	f.location "Location"
	f.start_date_string "January 1, 2000"
end
Factory.define :public_job, :parent => :job do |f|
	f.association :resume, :factory => :public_resume
end
Factory.define :language do |f|
	f.association :resume
	f.association :level
	f.sequence(:name) { |n| "My Language Name #{n}" }
end
Factory.define :public_language, :parent => :language do |f|
	f.association :resume, :factory => :public_resume
end
Factory.define :publication do |f|
	f.association :resume
	f.sequence(:name) { |n| "My Publication Name #{n}" }
	f.contribution "Contribution"
	f.sequence(:title) { |n| "My Publication Title #{n}" }
	f.date_string "January 1, 2000"
end
Factory.define :public_publication, :parent => :publication do |f|
	f.association :resume, :factory => :public_resume
end
Factory.define :school do |f|
	f.association :resume
	f.sequence(:name) { |n| "My School Name #{n}" }
	f.location "Location"
	f.start_date_string "January 1, 2000"
end
Factory.define :public_school, :parent => :school do |f|
	f.association :resume, :factory => :public_resume
end
Factory.define :skill do |f|
	f.association :resume
	f.association :level
	f.sequence(:name) { |n| "My Skill Name #{n}" }
	f.start_date_string "January 1, 2000"
end
Factory.define :public_skill, :parent => :skill do |f|
	f.association :resume, :factory => :public_resume
end
Factory.define :level do |f|
	f.sequence(:name) { |n| "My Level Name #{n}" }
	f.value 3
end



Factory.define :comment do |f|
	f.association :user
	f.body "Comment Body"
end
Factory.define :stop_comment, :parent => :comment do |f|
	f.association :commentable, :factory => :public_stop
end
Factory.define :entry_comment, :parent => :comment do |f|
	f.association :commentable, :factory => :public_entry
end

Factory.define :message do |f|
	f.sequence(:subject) { |n| "My Email Subject #{n}" }
	f.association :sender, :factory => :user
	f.association :recipient, :factory => :user
end

Factory.define :email do |f|
	f.sequence(:subject) { |n| "My Email Subject #{n}" }
	f.body    "Email Body"
	f.association :sender, :factory => :user
	f.association :recipient, :factory => :user
end

Factory.define :note do |f|
	f.association :user
	f.sequence(:title) { |n| "My Note Title #{n}" }
	f.body  "My Note Body"
end
Factory.define :private_note, :parent => :note do |f|
	f.public false
end
Factory.define :public_note, :parent => :note do |f|
	f.public true
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:title) { |n| "My Page Title #{n}" }
	f.body  "Page Body"
end

Factory.define :photo do |f|
	f.association :user
end

Factory.define :asset do |f|
	f.association :user
	f.sequence(:title) { |n| "My Asset Title #{n}" }
end
Factory.define :private_asset, :parent => :asset do |f|
end
Factory.define :public_asset, :parent => :asset do |f|
end


Factory.define :location do |f|
	f.association :user
	f.sequence(:name) { |n| "My Location #{n}" }
end

Factory.define :category do |f|
	f.association :user
	f.sequence(:name) { |n| "My Category #{n}" }
end

Factory.define :creator do |f|
	f.association :user
	f.sequence(:name) { |n| "My Creator #{n}" }
end

Factory.define :tag do |f|
	f.association :user
	f.sequence(:name) { |n| "My Tag #{n}" }
end

Factory.define :download do |f|
	f.association :user
	f.url "/mystuff"
end

Factory.define :tic_tac_toe do |f|
	f.association :player_1, :factory => :user
	f.association :player_2, :factory => :user
end

Factory.define :connect_four do |f|
	f.association :player_1, :factory => :user
	f.association :player_2, :factory => :user
end

Factory.define :mine_sweeper do |f|
	f.association :user
end

