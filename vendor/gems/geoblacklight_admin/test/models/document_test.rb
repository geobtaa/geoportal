require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  test "should not save document without title" do
    document = Document.new
    assert_not document.save, "Saved the document without a title"
  end

  test "should save document with minimal required attributes" do
    document = Document.new

    # Required attributes
    document.title = "Test Document"
    document.gbl_resourceClass_sm = ["Dataset"]
    document.geomg_id_s = "123456"
    document.dct_accessRights_s = "Public"

    assert document.save
  end

  # @TODO
  # Test the presence of the reference values
  # - From: Aardvark, Multiple Download Links, and Additional Assets

  test "should return an asset_label" do
    document = documents(:ag)
    asset_1 = assets(:asset_1) # Title no Label
    asset_2 = assets(:asset_2) # Title with Label (prefer label)

    assert_equal "Asset Title", document.asset_label(asset_1)
    assert_equal "Asset Label", document.asset_label(asset_2)
  end

  test "should respond to thumbnail_state_machine" do
    document = Document.new
    assert_respond_to document, :thumbnail_state_machine
    assert_instance_of DocumentThumbnailStateMachine, document.thumbnail_state_machine
  end

  test "should respond to raw_solr_document" do
    document = documents(:ag)
    assert_respond_to document, :raw_solr_document
  end

  test "should respond to item_viewer" do
    document = documents(:ag)
    assert_respond_to document, :item_viewer
    assert_instance_of GeoblacklightAdmin::ItemViewer, document.item_viewer
  end

  test "should respond to GBL SolrDocument convience methods" do
    document = documents(:ag)

    assert_respond_to document, :available?
    assert_equal true, document.available?

    # @TODO: fix document.references.download.to_hash call
    # assert_respond_to document, :downloadable?
    # assert_equal false, document.downloadable?

    assert_respond_to document, :public?
    assert_equal true, document.public?

    assert_respond_to document, :local?
    assert_equal false, document.local?

    assert_respond_to document, :restricted?
    assert_equal false, document.restricted?

    assert_respond_to document, :local_restricted?
    assert_equal false, document.local_restricted?

    assert_respond_to document, :same_institution?
    assert_equal false, document.same_institution?

    assert_respond_to document, :display_note
    assert_empty document.display_note

    assert_respond_to document, :rights_field_data
    assert_equal "Public", document.rights_field_data

    # assert_respond_to document, :direct_download

    # assert_respond_to document, :hgl_download
    # assert_respond_to document, :oembed
    # assert_respond_to document, :iiif_download
    # assert_respond_to document, :data_dictionary_download
    # assert_respond_to document, :external_url
    # assert_equal "http://example.com", document.external_url

    assert_respond_to document, :itemtype
    assert_equal "http://schema.org/Dataset", document.itemtype

    assert_respond_to document, :geom_field
    assert_equal "POLYGON((-80 25, -65 18, -64 33, -80 25))", document.geom_field

    assert_respond_to document, :wxs_identifier
    assert_equal "", document.wxs_identifier

    assert_respond_to document, :file_format
    assert_equal "Shapefile", document.file_format

    # assert_respond_to document, :checked_endpoint
  end

  test "should respond to current_version" do
    document = documents(:ag)
    assert_respond_to document, :current_version
    assert_equal 0, document.current_version
  end

  test "should respond to derive_polygon" do
    document = documents(:ag)
    assert_respond_to document, :derive_polygon
    assert_equal "POLYGON((-96.6391 43.5012, -90.1401 43.5012, -90.1401 40.3754, -96.6391 40.3754, -96.6391 43.5012))", document.derive_polygon

    document.dcat_bbox = "-180,-90,180,90"
    assert_equal "ENVELOPE(-180,180,90,-90)", document.derive_polygon

    document.dcat_bbox = ""
    assert_equal "", document.derive_polygon
  end
end
