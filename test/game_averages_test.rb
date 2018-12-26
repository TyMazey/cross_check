require_relative 'test_helper'

class GameAveragesTest < Minitest::Test

  def setup
    @game_1 = mock
    @game_2 = mock
    @game_3 = mock
    @games = [@game_1, @game_2, @game_3]
  end

  def test_it_can_calculate_home_win_percentage
    @game_1.stubs(outcome: "home", home_team_id: 6)
    @game_2.stubs(outcome: "home", home_team_id: 3)
    @game_3.stubs(outcome: "away", home_team_id: 6)
    stat_tracker = StatTracker.new

    assert_equal 50.0, stat_tracker.calc_home_win_percentages(6, @games)
    assert_equal 0.0, stat_tracker.calc_home_win_percentages(4, @games)
  end

  def test_it_can_calculate_away_win_percentage
    @game_1.stubs(outcome: "home", away_team_id: 3)
    @game_2.stubs(outcome: "home", away_team_id: 6)
    @game_3.stubs(outcome: "away", away_team_id: 3)
    stat_tracker = StatTracker.new

    assert_equal 50.0, stat_tracker.calc_away_win_percentages(3, @games)
    assert_equal 0.0, stat_tracker.calc_away_win_percentages(4, @games)
  end

  def test_it_can_determine_overall_win_percentage
    @game_1.stubs(outcome: "home", away_team_id: 3, home_team_id: 6)
    @game_2.stubs(outcome: "home", away_team_id: 6, home_team_id: 3)
    @game_3.stubs(outcome: "away", away_team_id: 3, home_team_id: 6)
    stat_tracker = StatTracker.new

    assert_equal 66.67, stat_tracker.calculate_win_percentage(3, @games)
    assert_equal 33.33, stat_tracker.calculate_win_percentage(6, @games)
    assert_equal 0.0, stat_tracker.calculate_win_percentage(4, @games)
  end
end
