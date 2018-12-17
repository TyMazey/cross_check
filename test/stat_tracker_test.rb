require_relative 'test_helper'

class StatTrackerTest < Minitest::Test

  def setup
    @locations = { games: "./data/game_test.csv",
                   teams: "./data/team_info_test.csv",
                   game_tests: "./data/game_teams_stats_test.csv"
                 }


  end

  def test_it_exists
    #skip
    stat_tracker = StatTracker.new

    assert_instance_of StatTracker, stat_tracker
  end

  def test_from_csv_returns_an_instance_of_stat_tracker
    #skip
    stat_tracker = StatTracker.from_csv(@locations)

    assert_instance_of StatTracker, stat_tracker
  end

  def test_it_can_return_file_informaiton
    skip
    stat_tracker = StatTracker.from_csv(@locations)


    assert_equal
  end

end
