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

  def find_all_by_away_team_id(id)
    @games.find_all do |game|
      game.away_team_id == id
    end
  end

  def find_all_by_home_team_id(id)
    @games.find_all do |game|
      game.home_team_id == id
    end
  end

  def find_wins_by_team(id)
    @games.find_all do |game|
      (game.home_team_id == id && game.outcome.include?("home") ||
       game.away_team_id == id && game.outcome.inclide?("away"))
     end
   end

   def find_losses_by_team(id)
     @games.find_all do |game|
       (game.away_team_id == id && game.outcome.include?("home") ||
        game.home_team_id == id && game.outcome.inclide?("away"))
      end
    end
end
