# frozen_string_literal: true

module FacetsHelper
  def local_facet_sort_buttons(facet_field)
    content_tag(:div, class: "sort-options btn-group") do
      if params["facet.sort"] == "index"
        content_tag(:span, "A-Z Sort", class: "active az btn btn-outline-secondary", data: {blacklight_modal: "preserve"}) +
          link_to("Numerical Sort", facet_sort_url("count", facet_field), class: "sort_change numeric btn btn-outline-secondary", data: {blacklight_modal: "preserve"})
      else
        link_to("A-Z Sort", facet_sort_url("index", facet_field), class: "sort_change az btn btn-outline-secondary", data: {blacklight_modal: "preserve"}) +
          content_tag(:span, "Numerical Sort", class: "active numeric btn btn-outline-secondary")
      end
    end
  end

  def facet_sort_url(sort_type, facet_field)
    url_for(request.query_parameters.merge(:controller => "catalog", :action => "facet", "facet_field" => facet_field, "facet.sort" => sort_type))
  end
end
