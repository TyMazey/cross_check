require_relative 'test_helper'

class StatTrackerTest < Minitest::Test

  def setup
    @locations = { games: "./data/game_test.csv",
                   teams: "./data/team_info_test.csv",
                   game_tests: "./data/game_teams_stats_test.csv"
                 }


  end

  def test_it_exists
    stat_tracker = StatTracker.new

    assert_instance_of StatTracker, stat_tracker
  end

  def test_from_csv_returns_an_instance_of_stat_tracker
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_return_file_informaiton
    stat_tracker = StatTracker.from_csv(@locations)

    expected_game = {game_id: "2012030221",
                     season: "20122013"}

    expected_team_info = {team_id: "1",
                          franchiseId: "23"}

    expected_game_info = {game_id: "2012030221",
                          team_id: "3"}

    assert_equal expected_game, stat_tracker.game_info
    assert_equal expected_game_info, stat_tracker.game_team_info
    assert_equal expected_team_info, stat_tracker.team_info
  end

end
