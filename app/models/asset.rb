class Asset < ActiveRecord::Base

	cattr_reader :per_page
	@@per_page = 50
	SORTABLE_COLUMNS = %w( Title Cost Value Price Created_At Updated_At Acquired_On Used_On Sold_On )
	FILTERS = [
		[ 'For Sale', 'ForSale' ],
		[ 'Not For Sale', '!ForSale' ],
		[ 'Sold', 'Sold' ],
		[ 'Not Sold', '!Sold' ],
		[ 'Used', 'Used' ],
		[ 'Not Used', '!Used' ],
		[ 'Acquired', 'Acquired' ],
		[ 'Not Acquired', '!Acquired' ],
		[ 'Borrowed', 'Borrowed' ],
		[ 'Not Borrowed', '!Borrowed' ],
		[ 'Want', 'Want' ]
	]

	acts_as_ownable

	#	modify acts_as_taggable to take params so
	#	that all these can be generalized
	#	with something like ...
	#	acts_as_taggable :categories, :category_taggings, :category_names


#	May want to remove these taggings and create a has_and_belongs_to_many relationship


	has_many :category_taggings, :dependent => :destroy
	has_many :categories, :through => :category_taggings
	attr_writer :category_names
	after_save :assign_categories

	has_many :creator_taggings, :dependent => :destroy
	has_many :creators, :through => :creator_taggings
	attr_writer :creator_names
	after_save :assign_creators

	has_many :location_taggings, :dependent => :destroy
	has_many :locations, :through => :location_taggings
	attr_writer :location_names
	after_save :assign_locations

	validates_presence_of :title
	validates_length_of	 :title, :minimum => 1

	attr_accessible :title, :description, :model, :serial, :cost, :value, :price,
		:acquired_on, :used_on, :sold_on, :for_sale,
		:acquired_on_string, :used_on_string, :sold_on_string,
		:location_names, :creator_names, :category_names

	stringify_date :acquired_on, :used_on, :sold_on

	def self.search(params={})
		joins = []
		conditions = {}
		matches = 1
		sql_scope = {}
		sql_conditions = []
		sql_values = []

		#	used by for_sale controller (fixed it)
		#conditions['assets.for_sale'] = params[:for_sale] if !params[:for_sale].blank?

		if !params[:title].blank?
			sql_conditions.push("title LIKE ?")
			sql_values.push("%#{params[:title].split().join('%')}%")
		end

		if !params[:filter].blank?
			params[:filter].each do |f|
				case f
					when /^(not_for_sale|!forsale)$/i
						sql_conditions.push("for_sale = false")
					when /^forsale$/i
						sql_conditions.push("for_sale = true")
					when /^(not_used|!used)$/i
						sql_conditions.push("used_on IS NULL")
					when /^used$/i
						sql_conditions.push("used_on IS NOT NULL")
					when /^(not_sold|!sold)$/i
						sql_conditions.push("sold_on IS NULL")
					when /^sold$/i
						sql_conditions.push("sold_on IS NOT NULL")
					when /^(not_acquired|!acquired)$/i
						sql_conditions.push("acquired_on IS NULL")
					when /^acquired$/i
						sql_conditions.push("acquired_on IS NOT NULL")
					when /^borrowed$/i
						sql_conditions.push("acquired_on IS NULL AND sold_on IS NULL AND used_on IS NOT NULL")
					when /^(not_borrowed|!borrowed)$/i
						sql_conditions.push("acquired_on IS NOT NULL AND sold_on IS NOT NULL AND used_on IS NULL")
					when /^want$/i
						sql_conditions.push("acquired_on IS NULL AND used_on IS NULL")
				end
			end
		end

		if !params[:category].blank?
			categories = params[:category].positive_filters
			not_categories = params[:category].negative_filters
			if !categories.empty?
				matches *= categories.length
				conditions['categories.name'] = categories
				joins.push(:categories)
			end
			if !not_categories.empty?
				sql_conditions.push("assets.id NOT IN ( SELECT DISTINCT asset_id FROM category_taggings INNER JOIN categories ON ( category_taggings.category_id = categories.id ) where categories.name IN (?) )");
				sql_values.push(not_categories)
			end
		end

		if !params[:creator].blank?
			creators = params[:creator].positive_filters
			not_creators = params[:creator].negative_filters
			if !creators.empty?
				matches *= creators.length
				conditions['creators.name'] = creators
				joins.push(:creators)
			end
			if !not_creators.empty?
				sql_conditions.push("assets.id NOT IN ( SELECT DISTINCT asset_id FROM creator_taggings INNER JOIN creators ON ( creator_taggings.creator_id = creators.id ) where creators.name IN (?) )");
				sql_values.push(not_creators)
			end
		end

		if !params[:location].blank?
			locations = params[:location].positive_filters
			not_locations = params[:location].negative_filters
			if !locations.empty?
				matches *= locations.length
				conditions['locations.name'] = locations
				joins.push(:locations)
			end
			if !not_locations.empty?
				sql_conditions.push("assets.id NOT IN ( SELECT DISTINCT asset_id FROM location_taggings INNER JOIN locations ON ( location_taggings.location_id = locations.id ) where locations.name IN (?) )");
				sql_values.push(not_locations)
			end
		end
		
		sort_column = untaint_column(params[:sort],:default => 'title')
		sort_column = ignore_articles_in_order_by('title') if sort_column == 'title'
		sort_dir = untaint_direction(params[:dir])
		order = "#{sort_column} #{sort_dir}"

		sql_scope[:conditions] = [ sql_conditions.join(' AND ') ]
		sql_values.each{|s|sql_scope[:conditions].push(s)}
		with_scope :find => sql_scope do
			find(:all, 
				:joins => joins,
				:conditions => conditions,
				:order => order,
				:select => 'DISTINCT assets.*, count(assets.id) as matches',
				:group  => 'assets.id',
				:having => "matches = #{matches}"
			)
		end
	end

#	def parse_tagging_params()
#		if !params[:category].blank?
#			categories = params[:category].names_to_array.delete_if{|s|s.index("!") == 0}
#			not_categories = params[:category].names_to_array.delete_if{|s|s.index("!") != 0}.map{|s|s.slice(1..-1)}
#			if !categories.empty?
#				matches *= categories.length
#				conditions['categories.name'] = categories
#				joins.push(:categories)
#			end
#			if !not_categories.empty?
#				sql_conditions.push("assets.id NOT IN ( SELECT DISTINCT asset_id FROM category_taggings INNER JOIN categories ON ( category_taggings.category_id = categories.id ) where categories.name IN (?) )");
#				sql_values.push(not_categories)
#			end
#		end
#	end

	def validate
		errors.add(:acquired_on, "is invalid") if acquired_on_invalid?
		errors.add(:used_on, "is invalid") if used_on_invalid?
		errors.add(:sold_on, "is invalid") if sold_on_invalid?
	end

	def category_names
		@category_names || categories.map(&:name).join(', ')
	end

	def creator_names
		@creator_names || creators.map(&:name).join(', ')
	end
	
	def location_names
		@location_names || locations.map(&:name).join(', ')
	end

	def sold?
		!sold_on.nil?
	end

	def for_sale?
		for_sale
	end

	def want?
		used_on.nil? and acquired_on.nil? and sold_on.nil?
	end

	def borrowed?	#	used, but never acquired or sold
		!used_on.nil? and acquired_on.nil? and sold_on.nil?
	end

	def used?
		!used_on.nil?
	end
	
private

	def assign_categories
		if @category_names	
			new_categories = @category_names.names_to_array.map do |name|
				Category.find_or_create({
					:name => name.squish,
					:user_id => self.user_id
				}) if !name.blank?
			end
			self.category_taggings.each do |ct|
				ct.destroy if !new_categories.collect(&:id).include?(ct.category_id)
			end
			self.categories = new_categories
		end
	end

	def assign_creators
		if @creator_names	
			new_creators = @creator_names.names_to_array.map do |name|
				Creator.find_or_create({
					:name => name.squish,
					:user_id => self.user_id
				}) if !name.blank?
			end
			self.creator_taggings.each do |ct|
				ct.destroy if !new_creators.collect(&:id).include?(ct.creator_id)
			end
			self.creators = new_creators
		end
	end

	def assign_locations
		if @location_names	
			new_locations = @location_names.names_to_array.map do |name|
				Location.find_or_create({
					:name => name.squish,
					:user_id => self.user_id
				}) if !name.blank?
			end
			self.location_taggings.each do |ct|
				ct.destroy if !new_locations.collect(&:id).include?(ct.location_id)
			end
			self.locations = new_locations
		end
	end

	def original_assign_categories
		#	will not decrement counter cache in category if category removed
		if @category_names	
			self.categories = @category_names.names_to_array.map do |name|
				Category.find_or_create({
					:name => name.squish,
					:user_id => self.user_id
				}) if !name.blank?
			end
		end
	end

	def original_assign_locations
		if @location_names
			self.locations = @location_names.names_to_array.map do |name|
				Location.find_or_create({
					:name => name.squish,
					:user_id => self.user_id
				}) if !name.blank?
			end
		end
	end

	def original_assign_creators
		if @creator_names
			self.creators = @creator_names.names_to_array.map do |name|
				Creator.find_or_create({
					:name => name.squish,
					:user_id => self.user_id
				}) if !name.blank?
			end
		end
	end

end
