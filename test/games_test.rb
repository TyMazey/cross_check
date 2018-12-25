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

    assert_equal [], @games.all
  end

  def test_it_can_create_a_new_game
    game = @games.create(@attributes)

    assert_equal 2012030221, @games.all.first.game_id
    assert_equal 2, @games.all.first.away_goals
    assert_equal 6, @games.all.first.home_team_id
  end

  def test_it_can_search_for_games_by_id
    game = @games.create(@attributes)

    assert_equal game.first, @games.find_by_id(2012030221)
  end

  def test_it_can_return_all_games_in_a_season
    attributes_2 = { game_id: "2012030222",
                    season: "20122013",
                    type: "P",
                    date_time: "2013-05-16",
                    away_team_id: "3",
                    home_team_id: "6",
                    away_goals: 2,
                    home_goals: 3,
                    outcome: "home win OT"
    }
    @games.create(@attributes)
    @games.create(attributes_2)


    assert_equal 2, @games.all.count
    assert_equal 2012030221, @games.all.first.game_id
    assert_equal 2012030222, @games.all.last.game_id
    assert_equal "home win OT", @games.all.last.outcome
    @games.all.each {|game| assert_instance_of Game, game}
  end

  def test_it_can_find_games_by_season_id
    attributes_2 = { game_id: "2012030222",
                    season: "20122013",
                    type: "P",
                    date_time: "2013-05-16",
                    away_team_id: "3",
                    home_team_id: "6",
                    away_goals: 2,
                    home_goals: 3,
                    outcome: "home win OT"
    }
    @games.create(@attributes)
    @games.create(attributes_2)

    assert_equal 2, @games.find_by_season_id(20122013).count
    assert_equal 2012030221, @games.find_by_season_id(20122013).first.game_id
    assert_equal 2012030222, @games.find_by_season_id(20122013).last.game_id
  end
end
