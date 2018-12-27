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

  def test_it_can_return_goals_each_team_has_allowed
    expected = {1 => 11,
                2 => 9,
                3 => 8
    }

    assert_equal expected, @stat_tracker.goals_allowed_by_team(@games)
  end

  def test_it_can_calculate_average_goals_for_home_and_away_games
    assert_equal 3.25, @stat_tracker.calc_average_goals(@games, true)
    assert_equal 3.75, @stat_tracker.calc_average_goals(@games, false)
    assert_equal 0, @stat_tracker.calc_average_goals([], true)
  end

  def test_goals_for_visitors_and_home_teams
    @games.each do |game|
      @stat_tracker.games.all.push(game)
    end
    expected = {1 => 5.5,
                2 => 3,
                3 => 1
    }
    expected_2 = {1 => 3,
                  2 => 3,
                  3 => 4
    }

    assert_equal expected, @stat_tracker.goals_for_visitors
    assert_equal expected_2, @stat_tracker.goals_for_home_teams
  end

  def test_total_scores
    assert_equal [7, 8, 3, 10], @stat_tracker.get_total_scores(@games)
  end

  def test_collection_of_goals_scored_by_team
    @games.each do |game|
      @stat_tracker.games.all.push(game)
    end

    assert_equal [4, 5, 2, 6], @stat_tracker.collection_of_goals_scored_by_team(1)
    assert_equal [3, 3], @stat_tracker.collection_of_goals_scored_by_team(2)
    assert_equal [1, 4], @stat_tracker.collection_of_goals_scored_by_team(3)
  end
end
