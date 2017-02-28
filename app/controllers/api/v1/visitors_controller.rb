class Api::V1::VisitorsController < ApplicationController
	
	# POST /api/v1/visitors
	# POST /api/v1/visitors.json
	def create
		# When a new access on property details page on client side will be sent a api request to
		# add the new user visit, can be a registered user or anonymous
		@api_v1_visitors = Visitor.create(api_v1_visitors_params)
		
		if @api_v1_visitors.save
			render json: :success, status: 200
		else
			render json: @api_v1_visitors.errors, status: :unprocessable_entity
		end
	end

	private

		def api_v1_visitors_params
			params.require(:visitors).permit(:user, :property)
		end
end
