require 'rails_helper'

RSpec.describe Api::V1::VisitorsController, type: :controller do
	describe "POST #create" do	
		before do 
			# @user = User.last.id
			@property = create(:property)
			@visit = create(:visitor, property: @property)
			request.env["HTTP_ACCESS"] = "application/json"
		end

		context "with 1 visitor valid" do
			it "save the visitor ans return success" do 
				visitors_count = Visitor.count
				post :create

				except(response.status).to eql(200)
				except(Visitor.count).to eql(visitors_count + 1)
			end
		end 
	end

end
