require 'rake'
require "application_system_test_case"

class HomePageTest < ApplicationSystemTestCase
  def setup
    Rails.application.load_tasks
    Rake::Task["geoportal:generate_centroids_json"].invoke
    visit '/'
  end

  def test_homepage_dom
    assert page.has_content?("Geoportal")
    assert page.has_selector?("header")
    assert page.has_selector?("header #application-header")
    assert page.has_selector?("#home-content")
    assert page.has_selector?("#wrapper-map")
  end

  def test_homepage_highlight_links
    assert page.has_link?(href: "/?f%5Bgbl_resourceClass_sm%5D%5B%5D=Datasets")
    assert page.has_link?(href: "/?f%5Bgbl_resourceClass_sm%5D%5B%5D=Maps")
    assert page.has_link?(href: "/?f%5Bgbl_resourceClass_sm%5D%5B%5D=Imagery")
  end

  def test_header_nav
    within("header") do

      # Bad Link - Should Fail
      assert page.has_no_link?("Google")

      # Footer Link - Should Fail
      assert page.has_no_link?("News & Updates")

      # Good Links - Should Pass
      assert page.has_no_link?("Bookmarks")
      assert page.has_no_link?("History")
      assert page.has_link?("About")
      assert page.has_link?("Help")
      assert page.has_no_link?("Login")
    end
  end

  def test_search
    within("div#home-content") do
      fill_in("q", with: 'water')
      click_button 'Search'
    end

    assert page.has_content?("Search Results")
  end

  def test_blank_search
    within("div#home-content") do
      fill_in("q", with: '')
      click_button 'Search'
    end

    assert page.has_content?("Search Results")
  end

  def test_map_clustering
    assert page.has_selector?("div.prunecluster")
  end
end
