require_relative '../test/test_helper'

class GoalAveragesTest < Minitest::Test

  def setup
    @game_1 = mock("1")
    @game_2 = mock("2")
    @game_3 = mock("3")
    @game_4 = mock("4")

    @game_1.stubs(home_team_id: 1, home_goals: 4, away_team_id: 2, away_goals: 3)
    @game_2.stubs(home_team_id: 2, home_goals: 3, away_team_id: 1, away_goals: 5)
    @game_3.stubs(home_team_id: 1, home_goals: 2, away_team_id: 3, away_goals: 1)
    @game_4.stubs(home_team_id: 3, home_goals: 4, away_team_id: 1, away_goals: 6)
    @games = [@game_1, @game_2, @game_3, @game_4]
    @stat_tracker = StatTracker.new
  end

  def test_it_can_return_total_goals_teams_have_scored
    expected = {1 => 17,
                2 => 6,
                3 => 5,
    }

    assert_equal expected, @stat_tracker.goals_scored_by_team(@games)
  end
end
