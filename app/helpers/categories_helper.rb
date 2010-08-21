module CategoriesHelper

	def categories_for_select
		options_for_select( 
			[['Apply New Category Filter',nil]] + 
			current_user.categories.collect{|c|
				[c.name,c.name]
			}.reject{|c|
				params[:category].include?(c[0]) if params[:category]
			}
		)
	end

end
