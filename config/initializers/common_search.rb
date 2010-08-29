module CommonSearch
	def self.included(base)
		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

	module ClassMethods

		def search(params={})
			joins = []
			conditions = {}
			matches = 1
			sql_scope = {}
			sql_conditions = []
			sql_values = []


			if !params[:user_id].blank?
				conditions["#{table_name}.user_id"] = params[:user_id]
			end

			if !params[:user].blank?
				conditions["#{table_name}.user_id"] = User.find_by_login(params[:user]).id
			end
	
			if !params[:title].blank?
				sql_conditions.push("title LIKE ?")
				sql_values.push("%#{params[:title].split().join('%')}%")
			end

			sort_column = untaint_column(params[:sort],:default => 'title')
			sort_dir    = untaint_direction(params[:dir])
			
			if !params[:tags].blank?
				tags = params[:tags].positive_filters
				not_tags = params[:tags].negative_filters
				if !tags.empty?
					matches *= tags.length
					conditions['tags.name'] = tags
					joins.push(:tags)
				end
				if !not_tags.empty?
					sql_conditions.push("#{table_name}.id NOT IN ( SELECT DISTINCT taggable_id FROM taggings INNER JOIN tags ON ( taggings.tag_id = tags.id ) where tags.name IN (?) AND taggable_type = '#{self.class_name}')");
					sql_values.push(not_tags)
				end
			end

			sql_scope[:conditions] = [ sql_conditions.join(' AND ') ]
			sql_values.each{|s|sql_scope[:conditions].push(s)}			
			with_scope :find => sql_scope do
				find(:all, 
					:joins => joins,
					:conditions => conditions,
					:order  => "#{sort_column} #{sort_dir}, title ASC",
					:select => "DISTINCT #{table_name}.*, count(#{table_name}.id) as matches",
					:group  => "#{table_name}.id",
					:having => "matches = #{matches}"
				)
			end
		end

	end

	module InstanceMethods
	end

end
