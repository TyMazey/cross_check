require_relative 'test_helper'

class GameAveragesTest < Minitest::Test

  def setup
    @game_1 = mock
    @game_2 = mock
    @game_3 = mock
    @games = [@game_1, @game_2, @game_3]
    @stat_tracker = StatTracker.new
  end

  def test_it_can_calculate_home_win_percentage
    @game_1.stubs(outcome: "home", home_team_id: 6)
    @game_2.stubs(outcome: "home", home_team_id: 3)
    @game_3.stubs(outcome: "away", home_team_id: 6)

    assert_equal 50.0, @stat_tracker.calc_home_win_percentages(6, @games)
    assert_equal 0.0, @stat_tracker.calc_home_win_percentages(4, @games)
  end

  def test_it_can_calculate_away_win_percentage
    @game_1.stubs(outcome: "home", away_team_id: 3)
    @game_2.stubs(outcome: "home", away_team_id: 6)
    @game_3.stubs(outcome: "away", away_team_id: 3)

    assert_equal 50.0, @stat_tracker.calc_away_win_percentages(3, @games)
    assert_equal 0.0, @stat_tracker.calc_away_win_percentages(4, @games)
  end

  def test_it_can_determine_overall_win_percentage
    @game_1.stubs(outcome: "home", away_team_id: 3, home_team_id: 6)
    @game_2.stubs(outcome: "home", away_team_id: 6, home_team_id: 3)
    @game_3.stubs(outcome: "away", away_team_id: 3, home_team_id: 6)

    assert_equal 0.67, @stat_tracker.calculate_win_percentage(3, @games)
    assert_equal 0.33, @stat_tracker.calculate_win_percentage(6, @games)
    assert_equal 0.0, @stat_tracker.calculate_win_percentage(4, @games)
  end

  def test_it_can_return_all_teams_win_ratios_for_a_season
    @game_1.stubs(outcome: "home", away_team_id: 3, home_team_id: 6,
                  season: 20122013, type: "R")
    @game_2.stubs(outcome: "home", away_team_id: 6, home_team_id: 3,
                  season: 20122013, type: "R")
    @game_3.stubs(outcome: "away", away_team_id: 3, home_team_id: 6,
                  season: 20132014, type: "R")
    @stat_tracker.games.all << @game_1
    @stat_tracker.games.all << @game_2
    @stat_tracker.games.all << @game_3


    twelve_thirteen = {3 => {"R" =>0.5},
                       6 => {"R" => 0.5}}

    thirteen_fourteen = {3 => {"R" => 1.0},
                         6 => {"R" => 0.0}}

    assert_equal twelve_thirteen, @stat_tracker.get_win_ratios_by_season(20122013)
    assert_equal thirteen_fourteen, @stat_tracker.get_win_ratios_by_season(20132014)
  end

  def test_it_can_translate_grouped_games_to_winrates
    @game_1.stubs(outcome: "home", away_team_id: 3, home_team_id: 6, season: 20122013)
    @game_2.stubs(outcome: "home", away_team_id: 6, home_team_id: 3, season: 20122013)
    @game_3.stubs(outcome: "away", away_team_id: 3, home_team_id: 6, season: 20132014)
    grouped_games = {
                      3 => {20122013 => [@game_1, @game_2],
                            20132014 => [@game_3]},
                      6 => {20122013 => [@game_1, @game_2],
                            20132014 => [@game_3]}
                    }


    expected =  {3 => {20122013 =>0.5,
                       20132014 => 1.0},
                 6 => {20122013 => 0.5,
                       20132014 => 0.0}}

    assert_equal expected, @stat_tracker.batch_map_hash_to_win_percentage(grouped_games)
  end

  def test_it_can_return_teams_win_loss_records
       @game_1.stubs(outcome: "home", home_team_id: "1", away_team_id: "2")
       @game_2.stubs(outcome: "away", home_team_id: "1", away_team_id: "2")
       @game_3.stubs(outcome: "home", home_team_id: "2", away_team_id: "1")
       team_1 = mock
       team_2 = mock("boo")
       team_1.stubs(id: "1", team_name: "Ravens")
       team_2.stubs(id: "2", team_name: "Slugs")
       @stat_tracker.games.all << @game_1
       @stat_tracker.games.all << @game_2
       @stat_tracker.games.all << @game_3
       @stat_tracker.teams.all << team_1
       @stat_tracker.teams.all << team_2


       expected_1 = {"Slugs" => 0.33}
       expected_2 = {"Ravens" => 0.67}

       assert_equal expected_1, @stat_tracker.win_loss_record("1")
       assert_equal expected_2, @stat_tracker.win_loss_record("2")
     end
end
