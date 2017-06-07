module Geoblacklight
  ##
  # Adds custom functionality for Geoblacklight document presentation
  class ShowPresenter < Blacklight::ShowPresenter
    class_attribute :document_references
    self.document_references = Geoblacklight::References

    class_attribute :thumbnail_url

    def references
      @references ||= document_references.new(document).refs
    end

    def thumbnail_reference
      self.references.find{|ref| ref.reference.first.include?('thumbnailUrl')}
    end

    def thumbnail_url
      self.thumbnail_reference.reference.last if self.thumbnail_reference.present?
    end
  end
end
