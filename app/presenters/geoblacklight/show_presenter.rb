module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class ShowPresenter < Blacklight::ShowPresenter
     class_attribute :thumbnail_presenter
     self.thumbnail_presenter = Blacklight::ThumbnailPresenter

    def thumbnail
      @thumbnail ||= thumbnail_presenter.new(document, view_context, view_config)
    end
  end
end
