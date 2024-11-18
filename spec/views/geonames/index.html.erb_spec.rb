require 'rails_helper'

RSpec.describe "geonames/index", type: :view do
  before(:each) do
    assign(:geonames, [
      Geoname.create!(
        :geonameid => "",
        :name => "Name",
        :asciiname => "Asciiname",
        :alternatenames => "MyText",
        :latitude => "9.99",
        :longitude => "9.99",
        :feature_class => "Feature Class",
        :feature_code => "Feature Code",
        :country_code => "Country Code",
        :cc2 => "Cc2",
        :admin1_code => "Admin1 Code",
        :admin2_code => "Admin2 Code",
        :admin3_code => "Admin3 Code",
        :admin4_code => "Admin4 Code",
        :population => "",
        :elevation => 2,
        :dem => 3,
        :timezone => "Timezone"
      ),
      Geoname.create!(
        :geonameid => "",
        :name => "Name",
        :asciiname => "Asciiname",
        :alternatenames => "MyText",
        :latitude => "9.99",
        :longitude => "9.99",
        :feature_class => "Feature Class",
        :feature_code => "Feature Code",
        :country_code => "Country Code",
        :cc2 => "Cc2",
        :admin1_code => "Admin1 Code",
        :admin2_code => "Admin2 Code",
        :admin3_code => "Admin3 Code",
        :admin4_code => "Admin4 Code",
        :population => "",
        :elevation => 2,
        :dem => 3,
        :timezone => "Timezone"
      )
    ])
  end

  it "renders a list of geonames" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Asciiname".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Feature Class".to_s, :count => 2
    assert_select "tr>td", :text => "Feature Code".to_s, :count => 2
    assert_select "tr>td", :text => "Country Code".to_s, :count => 2
    assert_select "tr>td", :text => "Cc2".to_s, :count => 2
    assert_select "tr>td", :text => "Admin1 Code".to_s, :count => 2
    assert_select "tr>td", :text => "Admin2 Code".to_s, :count => 2
    assert_select "tr>td", :text => "Admin3 Code".to_s, :count => 2
    assert_select "tr>td", :text => "Admin4 Code".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Timezone".to_s, :count => 2
  end
end
