require './test/test_helper'

class HomePageTest < CapybaraTestCase
  def test_user_can_see_the_homepage
    visit '/'

    assert page.has_content?("Welcome!")
    assert_equal 200, page.status_code
  end

  def test_it_has_error_page_for_unknown_urls
    visit '/not_found'

    assert page.has_content?("404 Page Not Found")
    assert_equal 404, page.status_code
  end
end
