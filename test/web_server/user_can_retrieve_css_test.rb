require './test/test_helper'

class CSSTest < CapybaraTestCase

  def test_user_can_receieve_css
    visit '/styles/style.css'

    assert_equal 200, page.status_code
    assert page.has_content?("background-color:")
  end
end
