require './test/test_helper'

class HomePageTest < CapybaraTestCase
  def test_user_can_nav_to_game_stats_page
    visit '/'
    click_on 'Game Statistics'

    assert_equal 200, page.status_code
    assert_equal '/game_statistics', current_path
    assert page.has_content?("Game Statistics")
  end

  def test_user_can_nav_to_league_stats_page
    visit '/'
    click_on 'League Statistics'

    assert_equal 200, page.status_code
    assert_equal '/league_stats', current_path
    assert page.has_content?("League Statistics")
  end

  def test_user_can_nav_to_season_stats_page
    visit '/'
    click_on 'Season Statistics'
    click_on '2013 - 2014'

    assert_equal 200, page.status_code
    assert_equal '/season_statistics', current_path
    assert page.has_content?("Season Statistics")
  end

  def test_user_can_nav_to_team_stats_page
    visit '/'
    click_on 'Team Statistics'

    assert_equal 200, page.status_code
    assert_equal '/team_stats', current_path
    assert page.has_content?("Team Statistics")
  end

  def test_user_can_navigate_to_about_page
    visit '/'
    click_on 'About Project'

    assert_equal 200, page.status_code
    assert_equal '/about', current_path
    assert page.has_content?("About")
  end
end
