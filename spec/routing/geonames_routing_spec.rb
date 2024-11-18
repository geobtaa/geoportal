require "rails_helper"

RSpec.describe GeonamesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/geonames").to route_to("geonames#index")
    end

    it "routes to #new" do
      expect(:get => "/geonames/new").to route_to("geonames#new")
    end

    it "routes to #show" do
      expect(:get => "/geonames/1").to route_to("geonames#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/geonames/1/edit").to route_to("geonames#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/geonames").to route_to("geonames#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/geonames/1").to route_to("geonames#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/geonames/1").to route_to("geonames#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/geonames/1").to route_to("geonames#destroy", :id => "1")
    end
  end
end
