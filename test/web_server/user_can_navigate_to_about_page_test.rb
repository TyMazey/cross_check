require './test/test_helper'

class HomePageTest < CapybaraTestCase
  def test_user_can_navigate_to_about_page
    visit '/'
    click_on "About"

    assert_equal 200, page.status_code
    assert_equal '/about', current_path
    assert page.has_content?("About the Project")
  end
end
