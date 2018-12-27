require_relative 'test_helper'

class GameTest < Minitest::Test

  def setup
    attributes = { game_id: "2012030221",
                    season: "20122013",
                    type: "P",
                    date_time: 2013-05-16,
                    away_team_id: "3",
                    home_team_id: "6",
                    away_goals: 2,
                    home_goals: 3,
                    outcome: "home win OT"
  }
  @game = Game.new(attributes)
  end

  def test_it_exsists

    assert_instance_of Game, @game
  end

  def test_it_attributes

    assert_equal 2012030221, @game.game_id
    assert_equal 20122013, @game.season
    assert_equal "P", @game.type
    assert_equal 2013-05-16, @game.date_time
    assert_equal 3, @game.away_team_id
    assert_equal 6, @game.home_team_id
    assert_equal 2, @game.away_goals
    assert_equal 3, @game.home_goals
    assert_equal "home win OT", @game.outcome
  end
end
