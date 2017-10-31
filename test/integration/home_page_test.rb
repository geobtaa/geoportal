require "test_helper"

class HomePageTest < Capybara::Rails::TestCase

  def setup
    visit '/'
  end

  def test_homepage_dom
    assert page.has_content?("Geoportal")
    assert page.has_selector?("header")
    assert page.has_selector?("header #btaa-header")
    assert page.has_selector?("header #application-header")
    assert page.has_selector?("section#home-search")
    assert page.has_selector?("section#home-metadata")
    assert page.has_selector?("section#map")
    assert page.has_selector?("section#footer-app")
    assert page.has_selector?("footer")
  end

  def test_header_nav
    within("header") do

      # Bad Link - Should Fail
      assert page.has_no_link?("Google")

      # Footer Link - Should Fail
      assert page.has_no_link?("News & Updates")

      # Good Links - Should Pass
      assert page.has_link?("Bookmarks")
      assert page.has_link?("History")
      assert page.has_link?("About")
      assert page.has_link?("Help")
      assert page.has_link?("Login")
    end
  end

  def test_footer_nav
    within("section#footer-app") do
      # Bad Link - Should Fail
      assert page.has_no_link?("Google")

      # Header Link - Should Fail
      assert page.has_no_link?("History")

      # Good Links - Should Pass
      assert page.has_link?("News & Updates")
      assert page.has_link?("About Us")
      assert page.has_link?("Contact Project Team")
      assert page.has_link?("Big Ten Academic Alliance Homepage")
    end
  end

  def test_search
    within("section#home-search") do
      fill_in("q", with: 'water')
      click_button 'Search'
    end

    assert page.has_content?("Search Results")
  end

  def test_blank_search
    within("section#home-search") do
      fill_in("q", with: '')
      click_button 'Search'
    end

    assert page.has_content?("Search Results")
  end

  def test_map_clustering
    assert page.has_selector?("div.prunecluster.leaflet-marker-icon")
  end

  def test_autocomplete
    within("section#home-search") do
      fill_in("q", with: 'minn')
    end

    assert page.has_content?("minneapolis, minnesota, united states")
  end
end
