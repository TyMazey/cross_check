require_relative 'test_helper'

class GamesTest < Minitest::Test

  def setup
    @attributes = { game_id: "2012030221",
                    season: "20122013",
                    type: "P",
                    date_time: 2013-05-16,
                    away_team_id: "3",
                    home_team_id: "6",
                    away_goals: 2,
                    home_goals: 3,
                    outcome: "home win OT"
  }
    @games = Games.new
  end

  def test_it_exsist

    assert_instance_of Games, @games
  end

  def test_it_starts_with_no_games

    assert_equal [], @games.all_games
  end

  def test_it_can_create_a_new_game
    game = @games.create(@attributes)

    assert_equal game, @games.all_games
  end

  def test_it_can_search_for_games_by_id
    game = @games.create(@attributes)

    assert_equal game.first, @games.find_by_id("2012030221")
  end

  def test_it_can_return_all_games_in_a_season
    attributes_2 = { game_id: "2012030222",
                    season: "20122014",
                    type: "P",
                    date_time: 2013-05-16,
                    away_team_id: "3",
                    home_team_id: "6",
                    away_goals: 2,
                    home_goals: 3,
                    outcome: "home win OT"
  }
  @games.create(@attributes)
  @games.create(attributes_2)


    assert_equal [@games.all_games.first], @games.find_by_season_id("20122013")
  end
end
