require_relative './game'

class Games

  def initialize
    @games = []
    @valid_selections = [:home_team_id,
                         :away_team_id,
                         :season,
                         :type,
                         :venue,
                         :outcome]
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
    group_games_by(:season)[id]
  end

  def find_wins_by_team(id)
    @games.find_all do |game|
      (game.home_team_id == id && game.outcome.include?("home") ||
       game.away_team_id == id && game.outcome.include?("away"))
    end
  end

  def find_losses_by_team(id)
    @games.find_all do |game|
      (game.away_team_id == id && game.outcome.include?("home") ||
       game.home_team_id == id && game.outcome.include?("away"))
    end
  end

   def find_all_by_team(id)
     find_wins_by_team(id) + find_losses_by_team(id)
   end

   def all_seasons_for_team(id)
     group_games_by(:season, find_all_by_team(id)).keys
   end

   def group_games_by_team(games = @games)
     games_by_team = {}
     games.each do |game|
       games_by_team[game.home_team_id] = [] if games_by_team[game.home_team_id] == nil
       games_by_team[game.home_team_id] << game
       games_by_team[game.away_team_id] = [] if games_by_team[game.away_team_id] == nil
       games_by_team[game.away_team_id] << game
     end
     games_by_team
   end

   def group_games_by(category, selection = @games)
     if @valid_selections.include?(category)
       grouped_category = selection.group_by do |game|
         game.send(category)
       end
       grouped_category.default=([])
       grouped_category
     else
       Hash.new([])
     end
   end
end
