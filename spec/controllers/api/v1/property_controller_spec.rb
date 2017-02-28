require 'rails_helper'

RSpec.describe Api::V1::PropertiesController, type: :controller do

  describe "GET #hot_properties" do
    before do 
      request.env["HTTP_ACCEPT"] = "appliction/json"
    end
    context "with 5 properties and 3 priority" do 
      before do
        @property1 = create(:property, priority: true, status: :active)
        @property2 = create(:property, priority: true, status: :active)
        @property3 = create(:property, priority: true, status: :active)
        @property4 = create(:property, priority: false, status: :active)
        @property5 = create(:property, priority: false, status: :active)
      end

      it "return 3 elements of result" do
        get :hot_properties
        expect(JSON.parse(response.body).count).to eql(3)
      end

      it "return 3 properties that are priority" do
        get :hot_properties
        expect(JSON.parse(response.body)[0]["property"]["priority"]).to eql(true)
        expect(JSON.parse(response.body)[1]["property"]["priority"]).to eql(true)
        expect(JSON.parse(response.body)[2]["property"]["priority"]).to eql(true)
      end
    end
    
     context "with 5 properties and 2 with priority" do
      before do
        @property3 = create(:property, status: :active, priority: false)
        @property2 = create(:property, status: :active, priority: true)
        @property4 = create(:property, status: :active, priority: false)
        @property1 = create(:property, status: :active, priority: true)
        @property5 = create(:property, status: :active, priority: false)
      end
 
      it "return 2 properties with priority and 1 without priority" do
        get :hot_properties
        priority_count = 0
        JSON.parse(response.body).each{ |prop| priority_count += 1 if prop["property"]["priority"] }

        expect(priority_count).to eql(2)
        # expect(JSON.parse(response.body)[0]["property"]["priority"]).to eql(true)
        # expect(JSON.parse(response.body)[1]["property"]["priority"]).to eql(true)
        # expect(JSON.parse(response.body)[2]["property"]["priority"]).to eql(false)
      end
    end
  end

  describe "POST #wishlist" do
    before do
      @user = create(:user)
      @property = create(:property)

      @auth_headers = @user.create_new_auth_token
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "with valid params and tokens" do
      before do
        request.headers.merge!(@auth_headers)
      end

      it "add to wishlist" do
        post :add_to_wishlist, params: {id: @property.id}
        @property.reload
        expect(@property.wishlists.last.id).to eql(Wishlist.last.id)
      end
    end

    context "with invalid tokens" do
      it "can't add to wishlist" do
        post :add_to_wishlist, params: {id: @property.id}
        expect(response.status).to eql(401)
      end
    end
  end

  describe "DELETE #wishlist" do
    before do
      @user     = create(:user)
      @property = create(:property)
      @wishlist = create(:wishlist, user: @user, property: @property)

      @auth_headers = @user.create_new_auth_token
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "with valid params and tokens" do
      before do
        request.headers.merge!(@auth_headers)
      end

      it "remove from wishlist" do
        delete :remove_from_wishlist, params: {id: @property.id}
        expect(Wishlist.all.count).to eql(0)
      end
    end

    context "with invalid tokens" do
      it "can't add to wishlist" do
        delete :remove_from_wishlist, params: {id: @property.id}
        expect(response.status).to eql(401)
      end

      it "whishlist keep existing" do
        delete :remove_from_wishlist, params: {id: @property.id}
        expect(Wishlist.all.count).not_to eql(0)
      end
    end
  end

  describe "GET #search" do
    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

    context "with a property associated a search query" do
      it "receive one result when property active" do
        @address = create(:address, city: 'Sao Paulo')
        @property = create(:property, address: @address, status: :active)
        # Force reindex
        Property.reindex

        get :search, params: {search: 'Sao Paulo'}
        expect(JSON.parse(response.body).count).to eql(1)
      end

      it "receive zero result when property not active" do
        @address = create(:address, city: 'Sao Paulo')
        @property = create(:property, address: @address, status: :inactive)
        # Force reindex
        Property.reindex

        get :search, params: {search: 'Sao Paulo'}
        expect(JSON.parse(response.body).count).to eql(0)
      end
    end

    context "without a property associated a search query" do
      it "receive zero result" do
        @address = create(:address, city: 'Sao Paulo')
        @property = create(:property, address: @address)
        # Force reindex
        Property.reindex

        get :search, params: {search: 'Manaus'}
        expect(JSON.parse(response.body).count).to eql(0)
      end
    end
  end

  describe "GET #autocomplete" do
    before do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context "with 2 existing properties ans 1 active" do
      before do
        @property1 = create(:property, status: :active)
        @property2 = create(:property, status: :inactive)
      end

      it "return 3 elements of result" do
        get :autocomplete
        expect(JSON.parse(response.body).count).to eql(3)
      end

      it "return the name of property, city and country of the property in 3 first elements" do   
        get :autocomplete

        expect(JSON.parse(response.body)[0]).to eql(@property1.name)
        expect(JSON.parse(response.body)[1]).to eql(@property1.address.city)
        expect(JSON.parse(response.body)[2]).to eql(@property1.address.country)
      end
    end

    context "with 2 existing properties an 0 active" do
      before do
        @property1 = create(:property, status: :inactive)
        @property2 = create(:property, status: :inactive)
      end

      it "return 0 elements of result" do
        get :autocomplete
        expect(JSON.parse(response.body).count).to eql(0)
      end
    end
  end
end
