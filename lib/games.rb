require_relative './game'

class Games

  def initialize
    @games = []
  end

  def all
    @games
  end

  def create(attributes)
    @games.push(Game.new(attributes))
  end

  def find_by_id(id)
    @games.find do |game|
      game.game_id == id
    end
  end

  def find_by_season_id(id)
    @games.find_all do |game|
      game.season == id
    end
  end
end
