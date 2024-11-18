require 'rails_helper'

RSpec.describe "Geonames", type: :request do
  describe "GET /geonames" do
    it "works! (now write some real specs)" do
      get geonames_path
      expect(response).to have_http_status(200)
    end
  end
end
