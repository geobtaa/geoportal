# frozen_string_literal: true

# DocumentHelper
#
# This module provides helper methods for handling document-related
# functionalities such as generating publication state badges, creating
# localized links, and handling pagination links.
module DocumentHelper
  # Generates a badge for the publication state of a document.
  #
  # @param document [Object] the document object containing the publication state
  # @return [String] HTML link with a span element representing the publication state
  def publication_state_badge(document)
    case document.publication_state
    when "draft"
      link_to("#document_publication_state") do
        tag.span("Draft", class: "badge badge-secondary")
      end
    when "published"
      link_to("#document_publication_state") do
        tag.span("Published", class: "badge badge-success")
      end
    when "unpublished"
      link_to("#document_publication_state") do
        tag.span("Unpublished", class: "badge badge-danger")
      end
    end
  end

  # Localizes a given link by parsing its URI and appending it to a base path.
  #
  # @param link [String] the link to be localized
  # @return [String] the localized link
  def localize_link(link)
    uri = URI.parse(link)
    "/admin/documents?#{uri.query}"
  end

  # Creates a sort link with a label and localized URL.
  #
  # @param link [Hash] a hash containing link attributes and self link
  # @return [String] HTML link element for sorting
  def sort_link(link)
    link_to link["attributes"]["label"], localize_link(link["links"]["self"]), {class: "dropdown-item"}
  end

  # Processes a link from an API response, determining whether to add or remove a facet.
  #
  # @param link [Hash] a hash containing links for adding or removing facets
  # @return [Hash] a hash with action and link keys
  def link_from_api(link)
    # Append facet - Full URI returned
    uri = URI.parse(link["links"]["self"])
    {action: "add", link: "/admin/documents?#{uri.query}"}
  rescue
    # Remove facet - Only path and query returned
    uri = URI.parse(link["links"]["remove"])
    {action: "remove", link: "/admin/documents?#{uri.query}"}
  end

  # Generates a link to the previous page in a paginated list.
  #
  # @param links [Hash] a hash containing pagination links
  # @return [String] HTML link element for the previous page
  def previous_link(links)
    if links["prev"]
      link_to "Previous", localize_link(links["prev"]), {class: "btn btn-outline-primary btn-sm"}
    else
      link_to "Previous", "javascript:;", {class: "btn btn-outline-primary btn-sm disabled", "aria-disabled": true}
    end
  end

  # Generates a link to the next page in a paginated list.
  #
  # @param links [Hash] a hash containing pagination links
  # @return [String] HTML link element for the next page
  def next_link(links)
    if links["next"]
      link_to "Next", localize_link(links["next"]), {class: "btn btn-outline-primary btn-sm"}
    else
      link_to "Next", "javascript:;", {class: "btn btn-outline-primary btn-sm disabled", "aria-disabled": true}
    end
  end

  # Constructs a link to a document's page in the Blacklight catalog.
  #
  # @param document [Object] the document object
  # @return [String] the URL to the document's Blacklight catalog page
  def blacklight_link(document)
    "#{BLACKLIGHT_URL}/catalog/#{document.friendlier_id}"
  end

  # Determines if a document's thumbnail should be rendered.
  #
  # @param document [Object] the document object
  # @return [Boolean] true if the thumbnail should be rendered, false otherwise
  def thumb_to_render?(document)
    document&.thumbnail&.file_url&.present? && document&.thumbnail&.file_derivatives&.present?
  end
end
