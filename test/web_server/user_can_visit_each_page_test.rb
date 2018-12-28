require './test/test_helper'

class HomePageTest < CapybaraTestCase
  def test_user_can_nav_to_game_stats_page
    visit '/'
    click_on 'Game Statistics'

  end

  def test_user_can_nav_to_league_stats_page
    visit '/'
    click_on 'League Statistics'
  end

  def test_user_can_nav_to_season_stats_page
    visit '/'
    click_on 'Season Statistics'
  end

  def test_user_can_nav_to_team_stats_page
    visit '/'
    click_on 'Team Statistics'
  end
end
