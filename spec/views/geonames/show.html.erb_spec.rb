require 'rails_helper'

RSpec.describe "geonames/show", type: :view do
  before(:each) do
    @geoname = assign(:geoname, Geoname.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Asciiname/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Feature Class/)
    expect(rendered).to match(/Feature Code/)
    expect(rendered).to match(/Country Code/)
    expect(rendered).to match(/Cc2/)
    expect(rendered).to match(/Admin1 Code/)
    expect(rendered).to match(/Admin2 Code/)
    expect(rendered).to match(/Admin3 Code/)
    expect(rendered).to match(/Admin4 Code/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Timezone/)
  end
end
