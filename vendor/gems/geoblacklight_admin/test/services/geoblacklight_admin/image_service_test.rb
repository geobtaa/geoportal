# frozen_string_literal: true

require "test_helper"

module GeoblacklightAdmin
  class ImageServiceTest < ActiveSupport::TestCase
    class MockDocument
      attr_reader :id, :thumbnail_state_machine, :viewer_protocol, :distributions

      def initialize
        @id = "test_doc_id"
        @thumbnail_state_machine = MockStateMachine.new
        @viewer_protocol = "wms"
        @distributions = {"http://schema.org/thumbnailUrl" => "http://example.com/distribution_thumbnail.jpg"}
      end

      def local_restricted?
        false
      end

      def available?
        true
      end
    end

    class MockStateMachine
      attr_reader :current_state

      def initialize
        @current_state = nil
      end

      def transition_to!(state, metadata)
        @current_state = state
      end
    end

    setup do
      @document = MockDocument.new
      @image_service = ImageService.new(@document)
    end

    test "initializes with a document" do
      assert_equal @document, @image_service.document
    end

    test "initializes metadata with solr_doc_id and placeheld" do
      assert_equal @document.id, @image_service.instance_variable_get(:@metadata)["solr_doc_id"]
      assert_equal false, @image_service.instance_variable_get(:@metadata)["placeheld"]
    end

    test "transitions document thumbnail state to processing on initialize" do
      assert_equal :processing, @document.thumbnail_state_machine.current_state
    end

    test "store method attaches image when io_file is present" do
      @image_service.stub :image_tempfile, Tempfile.new("test.jpg") do
        @image_service.stub :attach_io, true do
          assert @image_service.store
        end
      end
    end

    test "store method transitions to placeheld when io_file is nil" do
      @image_service.stub :image_tempfile, nil do
        @image_service.store
        assert_equal :placeheld, @document.thumbnail_state_machine.current_state
      end
    end

    test "store method transitions to failed on exception" do
      @image_service.stub :image_tempfile, -> { raise StandardError } do
        @image_service.store
        assert_equal :failed, @document.thumbnail_state_machine.current_state
      end
    end

    test "image_url returns gblsi_thumbnail_uri when present" do
      @image_service.stub :gblsi_thumbnail_uri, "http://example.com/thumbnail.jpg" do
        assert_equal "http://example.com/thumbnail.jpg", @image_service.send(:image_url)
      end
    end

    test "image_url falls back to service_url when gblsi_thumbnail_uri is not present" do
      @image_service.stub :gblsi_thumbnail_uri, nil do
        @image_service.stub :service_url, "http://example.com/service_thumbnail.jpg" do
          assert_equal "http://example.com/service_thumbnail.jpg", @image_service.send(:image_url)
        end
      end
    end

    test "image_url falls back to image_distribution when gblsi_thumbnail_uri and service_url are not present" do
      @image_service.stub :gblsi_thumbnail_uri, nil do
        @image_service.stub :service_url, nil do
          assert_equal "http://example.com/distribution_thumbnail.jpg", @image_service.send(:image_url)
        end
      end
    end
  end
end
