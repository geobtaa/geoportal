require 'rails_helper'

RSpec.describe "geonames/edit", type: :view do
  before(:each) do
    @geoname = assign(:geoname, Geoname.create!(
      :geonameid => "",
      :name => "MyString",
      :asciiname => "MyString",
      :alternatenames => "MyText",
      :latitude => "9.99",
      :longitude => "9.99",
      :feature_class => "MyString",
      :feature_code => "MyString",
      :country_code => "MyString",
      :cc2 => "MyString",
      :admin1_code => "MyString",
      :admin2_code => "MyString",
      :admin3_code => "MyString",
      :admin4_code => "MyString",
      :population => "",
      :elevation => 1,
      :dem => 1,
      :timezone => "MyString"
    ))
  end

  it "renders the edit geoname form" do
    render

    assert_select "form[action=?][method=?]", geoname_path(@geoname), "post" do

      assert_select "input[name=?]", "geoname[geonameid]"

      assert_select "input[name=?]", "geoname[name]"

      assert_select "input[name=?]", "geoname[asciiname]"

      assert_select "textarea[name=?]", "geoname[alternatenames]"

      assert_select "input[name=?]", "geoname[latitude]"

      assert_select "input[name=?]", "geoname[longitude]"

      assert_select "input[name=?]", "geoname[feature_class]"

      assert_select "input[name=?]", "geoname[feature_code]"

      assert_select "input[name=?]", "geoname[country_code]"

      assert_select "input[name=?]", "geoname[cc2]"

      assert_select "input[name=?]", "geoname[admin1_code]"

      assert_select "input[name=?]", "geoname[admin2_code]"

      assert_select "input[name=?]", "geoname[admin3_code]"

      assert_select "input[name=?]", "geoname[admin4_code]"

      assert_select "input[name=?]", "geoname[population]"

      assert_select "input[name=?]", "geoname[elevation]"

      assert_select "input[name=?]", "geoname[dem]"

      assert_select "input[name=?]", "geoname[timezone]"
    end
  end
end
