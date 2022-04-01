require 'test_helper'

class SolrDocumentTest < ActiveSupport::TestCase
  def setup
    cat = Blacklight::SearchService.new(
      config: CatalogController.blacklight_config
    )
    _resp, @document = cat.fetch("99-0001-test")
  end

  test 'supports B1G access links' do
    assert @document.respond_to? :access_links
  end

  test 'supports B1G image attribute' do
    assert @document.respond_to? :b1g_image
  end

  test 'supports resource_class' do
    assert @document.respond_to? :resource_class
  end
end
