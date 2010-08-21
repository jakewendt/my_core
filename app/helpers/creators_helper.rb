module CreatorsHelper

	def creators_for_select
		options_for_select( 
			[['Apply New Creator Filter',nil]] + 
			current_user.creators.collect{|c|
				[c.name,c.name]
			}.reject{|c|
				params[:creator].include?(c[0]) if params[:creator]
			}
		)
	end

end
