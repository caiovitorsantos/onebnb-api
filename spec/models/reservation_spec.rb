require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe Reservation, '.evaluated' do
  	before do
  		@user 		= create(:user)
  		@property = create(:property)
  		@comment 	= FFaker::Lorem.paragraph
  	end

  	it "Create valid comment" do
  		reservation = create(:reservation, property: @property, evaluation: false, user: @user)
  		reservation.evaluate @comment, 5
  		expect(Comment.last.body).to eql(@comment)
  	end

  	it "Create valid rating" do  
  		reservation = create(:reservation, property: @property, evaluation: false, user: @user)
  		reservation.evaluate @comment, 1
  	  reservation = create(:reservation, property: @property, evaluation: false, user: @user)
  		reservation.evaluate @comment, 2
  	  reservation = create(:reservation, property: @property, evaluation: false, user: @user)
  		reservation.evaluate @comment, 3

  		@property.reload

  		# Rating (1 + 2 + 3) / 3 = 2
  		expect(@property.get_rating).to eql(2)
  	end
  end
end
