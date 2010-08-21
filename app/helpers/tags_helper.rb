module TagsHelper

	def tags_for_select
		options_for_select( 
			[['Apply New Tag Filter',nil]] + 
			current_user.tags.collect{|c|
				[c.name,c.name]
			}.reject{|c|
				params[:tags].downcase.include?(c[0].downcase) if params[:tags]
			}
		)
	end

end
