require './test/test_helper'

class HomePageTest < CapybaraTestCase
  def test_user_can_nav_to_game_stats_page
    visit '/'
    click_on 'Game Statistics'

    assert_equal 200, page.status_code
    assert_equal '/game_stats', current_path
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

    assert_equal 200, page.status_code
    assert_equal '/season_stats', current_path
    assert page.has_content?("Season Statistics")
  end

  def test_user_can_nav_to_team_stats_page
    visit '/'
    click_on 'Team Statistics'

    assert_equal 200, page.status_code
    assert_equal '/team_stats', current_path
    assert page.has_content?("Team Statistics")
  end
end
