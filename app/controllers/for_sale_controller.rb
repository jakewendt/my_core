class ForSaleController < ApplicationController
	before_filter :login_required
	before_filter :require_asset_for_sale, :only => :show

	def index
		@page_title = "For Sale"
#		@assets = Asset.search(params.merge(:for_sale => true)).paginate({
		@assets = Asset.search(params.merge(:filter => ['forsale'])).paginate({
			:page => params[:page],
			:per_page => params[:per_page]||PER_PAGE
		})
	end

protected

	def require_asset_for_sale
		@asset = Asset.find(params[:id])
		unless ( @asset.for_sale )
			permission_denied("Asset not for sale")
		end
	end

end
