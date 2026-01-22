# frozen_string_literal: true

require "test_helper"
require "webmock/minitest"

class BlacklightApiIdsTest < ActiveSupport::TestCase
  include WebMock::API

  setup do
    @request = "http://localhost:3000/admin/api"
    @default_args = {
      q: "test",
      page: 1,
      sort: "score+desc%2C+dc_title_sort+asc",
      rows: 1000
    }
    @blacklight_api_ids = BlacklightApiIds.new(@request, @default_args)
    @response_body = {
      "data" => [{"id" => "1"}, {"id" => "2"}],
      "included" => [
        {"type" => "facet", "id" => "facet1"},
        {"type" => "sort", "id" => "sort1"}
      ],
      "meta" => {"total" => 2},
      "links" => {"self" => "http://localhost:3000/admin/api?page=1"}
    }.to_json

    stub_request(:get, "#{@request}#{BLACKLIGHT_JSON_API_IDS}")
      .with(query: @default_args)
      .to_return(status: 200, body: @response_body, headers: {"Content-Type" => "application/json"})
  end

  test "fetch makes a request to the API and returns the response" do
    response = @blacklight_api_ids.fetch
    assert_equal 200, response.code
    assert_equal JSON.parse(@response_body), response.parsed_response
  end

  test "results returns the data from the API response" do
    assert_equal [{"id" => "1"}, {"id" => "2"}], @blacklight_api_ids.results
  end

  test "facets returns the facets from the API response" do
    assert_equal [{"type" => "facet", "id" => "facet1"}], @blacklight_api_ids.facets
  end

  test "sorts returns the sorts from the API response" do
    assert_equal [{"type" => "sort", "id" => "sort1"}], @blacklight_api_ids.sorts
  end

  test "meta returns the meta information from the API response" do
    assert_equal({"total" => 2}, @blacklight_api_ids.meta)
  end

  test "links returns the links from the API response" do
    assert_equal({"self" => "http://localhost:3000/admin/api?page=1"}, @blacklight_api_ids.links)
  end

  test "load_all loads documents by friendlier_id" do
    assert_equal 2, @blacklight_api_ids.load_all.size
  end

  test "pluck returns specified fields from loaded documents" do
    skip("@TODO: Fix this test")
    assert_equal ["Agricultural Districts: Iowa", "Test Document"], @blacklight_api_ids.pluck("dct_title_s")
  end

  test "append_facets adds facets to options" do
    options = {q: "*", f: {"genre" => ["Map"]}}
    result = @blacklight_api_ids.send(:append_facets, {"genre" => ["Map"]}, options)
    assert_equal({q: "*", f: {"genre" => ["Map"]}}, result)
  end

  test "append_facets does not change options when facets are nil" do
    options = {q: "*"}
    result = @blacklight_api_ids.send(:append_facets, nil, options)
    assert_equal({q: "*"}, result)
  end

  test "prep_daterange converts date range string to solr format" do
    start_date, end_date = @blacklight_api_ids.send(:prep_daterange, "01/01/2020 - 12/31/2020")
    assert_equal "2020-01-01T00:00:00", start_date
    assert_equal "2020-12-31T23:59:59", end_date
  end

  test "append_daterange adds daterange to options" do
    options = {q: "*", daterange: "01/01/2020 - 12/31/2020"}
    result = @blacklight_api_ids.send(:append_daterange, options[:daterange], options)
    expected_daterange = "[2020-01-01T00:00:00 TO 2020-12-31T23:59:59]"
    assert_equal expected_daterange, result[:f][:date_created_drsim]
  end

  test "append_daterange does nothing if daterange is nil" do
    skip("@TODO: Fix this test")
    options = {q: "*"}
    result = @blacklight_api_ids.send(:append_daterange, nil, options)
    assert_equal({q: "*"}, result)
  end
end
