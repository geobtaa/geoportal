class ApplicationHelperTest < ActionView::TestCase
  test "citation date - YYYY" do
    assert_equal "1929", citation_dct_issued_s('1929')
  end

  test "citation date - 1/15/2016" do
    assert_equal "Jan 15, 2016", citation_dct_issued_s('1/15/2016')
  end

  test "citation date - 2003-01-28" do
    assert_equal "Jan 28, 2003", citation_dct_issued_s('2003-01-28')
  end

  test "citation date - 2015-11-18T11:02:15.705119" do
    assert_equal "Nov 18, 2015", citation_dct_issued_s('2015-11-18T11:02:15.705119')
  end
end
