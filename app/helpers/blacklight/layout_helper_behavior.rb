# frozen_string_literal: true

# Methods added to this helper will be available to all templates in the hosting
# application
module Blacklight
  # A module for useful methods used in layout configuration
  module LayoutHelperBehavior
    ##
    # Classes added to a document's show content div
    # @return [String]
    def show_content_classes
      "#{item_view_main_content_classes} show-document"
    end

    ##
    # Attributes to add to the <html> tag (e.g. lang and dir)
    # @return [Hash]
    def html_tag_attributes
      { lang: I18n.locale }
    end

    ##
    # Classes added to a document's sidebar div
    # @return [String]
    def show_sidebar_classes
      "#{item_view_sidebar_classes} show-document"
    end

    ##
    # Classes used for sizing the main content of a Blacklight page
    # @return [String]
    def item_view_main_content_classes
      'col-lg-8'
    end

    ##
    # Classes used for sizing the sidebar content of a Blacklight page
    # @return [String]
    def item_view_sidebar_classes
      'page-sidebar col-lg-4'
    end

    ##
    # Classes used for sizing the main content of a Blacklight page
    # @return [String]
    def main_content_classes
      'col-lg-9'
    end

    ##
    # Classes used for sizing the sidebar content of a Blacklight page
    # @return [String]
    def sidebar_classes
      'page-sidebar col-lg-3'
    end

    ##
    # Class used for specifying main layout container classes. Can be
    # overwritten to return 'container-fluid' for Bootstrap full-width layout
    # @return [String]
    def container_classes
      'container-fluid'
    end
  end
end
