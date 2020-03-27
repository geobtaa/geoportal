class ApplicationHelperTest < ActionView::TestCase
  test "citation date - YYYY" do
    assert_equal "1929", citation_dct_issued_s('1929')
  end

  test "citation date - 1/15/2016" do
    assert_equal "2016", citation_dct_issued_s('1/15/2016')
  end

  test "citation date - 2003-01-28" do
    assert_equal "2003", citation_dct_issued_s('2003-01-28')
  end

  test "citation date - 2015-11-18T11:02:15.705119" do
    assert_equal "2015", citation_dct_issued_s('2015-11-18T11:02:15.705119')
  end

  test "citation date - 2004-01-00" do
    assert_equal "2004", citation_dct_issued_s('2004-01-00')
  end

  test "citation date - 9999" do
    assert_equal "n.d.", citation_dct_issued_s('9999')
  end
end
