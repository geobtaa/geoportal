require 'test_helper'
require 'webmock/minitest'

class UriServiceTest < ActiveSupport::TestCase
  class MockStateMachine
    attr_reader :current_state, :metadata

    def transition_to!(state, metadata)
      @current_state = state
      @metadata = metadata
    end
  end

  class MockSolrDocumentUri
    attr_reader :document_id, :uri_key, :uri_value, :version, :id, :state_machine

    def initialize(uri_value)
      @document_id = '123'
      @uri_key = 'test_key'
      @uri_value = uri_value
      @version = '1'
      @id = 1
      @state_machine = MockStateMachine.new
    end
  end

  setup do
    @solr_document_uri = MockSolrDocumentUri.new('http://example.com')
  end

  test "process successful HTTP URI" do
    stub_request(:get, "http://example.com").to_return(status: 200)
    
    service = UriService.new(@solr_document_uri)
    service.process

    assert_equal :succeeded, @solr_document_uri.state_machine.current_state
  end

  test "process redirected HTTP URI" do
    stub_request(:get, "http://example.com").
      to_return(status: 301, headers: { 'Location' => 'http://new-example.com' })
    stub_request(:get, "http://new-example.com").to_return(status: 200)
    
    service = UriService.new(@solr_document_uri)
    service.process

    assert_equal :succeeded, @solr_document_uri.state_machine.current_state
  end

  test "process failed HTTP URI" do
    stub_request(:get, "http://example.com").to_return(status: 404)
    
    service = UriService.new(@solr_document_uri)
    service.process

    assert_equal :failed, @solr_document_uri.state_machine.current_state
  end

  test "process successful FTP URI with file" do
    @solr_document_uri = MockSolrDocumentUri.new('ftp://example.com/file.txt')
    
    ftp_mock = Minitest::Mock.new
    ftp_mock.expect :passive=, nil, [true]
    ftp_mock.expect :login, nil, ['anonymous', 'anonymous@google.com']
    ftp_mock.expect :size, 100, ['file.txt']

    Net::FTP.stub :open, nil, ftp_mock do
      service = UriService.new(@solr_document_uri)
      service.process

      assert_equal :succeeded, @solr_document_uri.state_machine.current_state
      assert_mock ftp_mock
    end
  end

  test "process successful FTP URI with directory" do
    @solr_document_uri = MockSolrDocumentUri.new('ftp://example.com/dir')
    
    ftp_mock = Minitest::Mock.new
    ftp_mock.expect :passive=, nil, [true]
    ftp_mock.expect :login, nil, ['anonymous', 'anonymous@google.com']
    ftp_mock.expect :chdir, nil, ['dir']
    ftp_mock.expect :pwd, '/dir'

    Net::FTP.stub :open, nil, ftp_mock do
      service = UriService.new(@solr_document_uri)
      service.process

      assert_equal :succeeded, @solr_document_uri.state_machine.current_state
      assert_mock ftp_mock
    end
  end

  test "process failed FTP URI with non-existent file" do
    @solr_document_uri = MockSolrDocumentUri.new('ftp://example.com/nonexistent.txt')
    
    ftp_mock = Minitest::Mock.new
    ftp_mock.expect :passive=, nil, [true]
    ftp_mock.expect :login, nil, ['anonymous', 'anonymous@google.com']
    ftp_mock.expect :size, 0, ['nonexistent.txt']

    Net::FTP.stub :open, nil, ftp_mock do
      service = UriService.new(@solr_document_uri)
      service.process

      assert_equal :failed, @solr_document_uri.state_machine.current_state
      assert_mock ftp_mock
    end
  end

  test "process failed FTP URI with non-existent directory" do
    @solr_document_uri = MockSolrDocumentUri.new('ftp://example.com/nonexistent')
    
    ftp_mock = Minitest::Mock.new
    ftp_mock.expect :passive=, nil, [true]
    ftp_mock.expect :login, nil, ['anonymous', 'anonymous@google.com']
    ftp_mock.expect :chdir, nil do
      raise Net::FTPPermError, "550 Failed to change directory."
    end
  
    Net::FTP.stub :open, nil, ftp_mock do
      service = UriService.new(@solr_document_uri)
      service.process
  
      assert_equal :failed, @solr_document_uri.state_machine.current_state
      assert_mock ftp_mock
    end
  end
end