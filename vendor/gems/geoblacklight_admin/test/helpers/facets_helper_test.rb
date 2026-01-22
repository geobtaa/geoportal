# frozen_string_literal: true

require "test_helper"

class FacetsHelperTest < ActionView::TestCase
  include FacetsHelper

  setup do
    @request = ActionDispatch::TestRequest.create
    @controller = CatalogController.new
    @controller.request = @request
  end

  test "local_facet_sort_buttons with index sort" do
    params["facet.sort"] = "index"
    # Stub the facet_sort_url method
    stub(:facet_sort_url, "/stubbed_url") do
      result = local_facet_sort_buttons("test_field")

      assert_match 'class="sort-options btn-group"', result
      assert_match '<span class="active az btn btn-outline-secondary"', result
      assert_match ">A-Z Sort</span>", result
      assert_match 'class="sort_change numeric btn btn-outline-secondary"', result
      assert_match ">Numerical Sort</a>", result
    end
  end

  test "local_facet_sort_buttons with count sort" do
    params["facet.sort"] = "count"
    # Stub the facet_sort_url method
    stub(:facet_sort_url, "/stubbed_url") do
      result = local_facet_sort_buttons("test_field")

      assert_match 'class="sort-options btn-group"', result
      assert_match 'class="sort_change az btn btn-outline-secondary"', result
      assert_match ">A-Z Sort</a>", result
      assert_match '<span class="active numeric btn btn-outline-secondary"', result
      assert_match ">Numerical Sort</span>", result
    end
  end

  test "facet_sort_url generates correct URL" do
    # Stub the url_for method to return a fixed URL
    stub(:url_for, "/stubbed_url") do
      url = facet_sort_url("index", "test_field")
      assert_equal "/stubbed_url", url
    end
  end
end
