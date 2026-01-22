# frozen_string_literal: true

require "httparty"

# BlacklightApi
class BlacklightApi
  include HTTParty

  default_timeout 300

  def initialize(request, args)
    defaults = {
      q: "*",
      page: 1,
      sort: "score+desc%2C+dc_title_sort+asc",
      rows: 20
    }
    @request = request
    @options = defaults.merge(args)
    append_facets(@options[:f], @options)
    append_daterange(@options[:f], @options)
    @options.compact!
  end

  def fetch
    @fetch ||= self.class.get("#{@request}#{BLACKLIGHT_JSON_API}", query: @options)
  end

  def results
    fetch["data"]
  end

  def facets
    fetch["included"]&.select { |s| s["type"] == "facet" }
  end

  def sorts
    fetch["included"].select { |s| s["type"] == "sort" }
  end

  def meta
    fetch["meta"]
  end

  def links
    fetch["links"]
  end

  def load_all
    results.map { |result| Document.find_by(friendlier_id: result["id"]) }
  end

  def pluck(field)
    load_all.pluck(field.to_sym)
  end

  private

  def append_facets(facets, options)
    options[:f] = facets if facets.present?
    options
  end

  def prep_daterange(daterange)
    start_date, end_date = daterange.split(" - ")
    start_date = Date
      .strptime(start_date, "%m/%d/%Y")
      .beginning_of_day
      .to_time
      .strftime("%Y-%m-%dT%H:%M:%S")

    end_date = Date
      .strptime(end_date, "%m/%d/%Y")
      .end_of_day
      .to_time
      .strftime("%Y-%m-%dT%H:%M:%S")

    [start_date, end_date]
  end

  def append_daterange(_daterange, options)
    return if options[:daterange].nil?

    unless options[:daterange].empty?
      start_date, end_date = prep_daterange(options[:daterange])
      if options[:f].present?
        options[:f][:date_created_drsim] = "[#{start_date} TO #{end_date}]"
      else
        options[:f] = {date_created_drsim: "[#{start_date} TO #{end_date}]"}
      end
    end
    options
  end
end
