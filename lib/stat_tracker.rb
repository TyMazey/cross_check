require 'csv'
require_relative './games'
require_relative './teams'
require_relative './csv_reader'
require_relative './game_statistics'
require_relative './summaries'
require_relative './team_statistics'
require_relative './league_statistics'


class StatTracker
  include CSVReader,
          GameStatistics,
          Summaries,
          TeamStatistics,
          LeagueStatistics

  attr_reader :games,
              :teams

  def initialize
    @games = Games.new
    @teams = Teams.new
  end

  def self.from_csv(locations)
    stat_tracker = self.new
    stat_tracker.from_csv(locations)
  end

  def group_games_by_team
    games_by_team = {}
    @teams.all.each do |team|
      games_by_team[team.id] = @games.all.find_all do |game|
        game.home_team_id == team.id || game.away_team_id == team.id
      end
    end
    games_by_team
  end

  def goals_for_visitors
    teams_away_goals = {}
    @games.group_games_by(:away_team_id).each do |team, games|
      teams_away_goals[team] = calc_average_goals(games, false)
    end
    teams_away_goals
  end

  def goals_for_home_teams
    teams_home_goals = {}
    @games.group_games_by(:home_team_id).each do |team, games|
      teams_home_goals[team] = calc_average_goals(games, true)
    end
    teams_home_goals
  end

  def goals_scored_by_team(games = @games.all)
    games.inject(Hash.new(0)) do |goals_by_team_id, game|
      goals_by_team_id[game.away_team_id] += game.away_goals
      goals_by_team_id[game.home_team_id] += game.home_goals
      goals_by_team_id
    end
  end

  def goals_allowed_by_team(games = @games.all)
    games.inject(Hash.new(0)) do |goals_by_team_id, game|
      goals_by_team_id[game.away_team_id] += game.home_goals
      goals_by_team_id[game.home_team_id] += game.away_goals
      goals_by_team_id
    end
  end

  def get_win_ratios_by_season(season)
    games_in_season = @games.find_by_season_id(season)
    games_by_team = group_selected_games_by_team(games_in_season)
    grouped_games_by_type = group_team_games_by_type(games_by_team)
    batch_map_hash_to_win_percentage(grouped_games_by_type)
  end

  def group_selected_games_by_team(season)
    games_by_team = {}
    season.each do |game|
      games_by_team[game.home_team_id] = [] if games_by_team[game.home_team_id] == nil
      games_by_team[game.home_team_id] << game
      games_by_team[game.away_team_id] = [] if games_by_team[game.away_team_id] == nil
      games_by_team[game.away_team_id] << game
    end
    games_by_team
  end

  def group_team_games_by_type(by_team)
    final = {}
    by_team.each do |team_id, games|
      final[team_id] = @games.group_games_by(:type, games)
    end
    final
  end

  def batch_map_hash_to_win_percentage(grouped_games)
    final = {}
    grouped_games.each do |team_id, by_season|
      final[team_id] = Hash.new(0.0)
      by_season.each do |type, games|
        final[team_id][type] = calculate_win_percentage(team_id, games)
      end
    end
    final
  end

  def collection_of_goals_scored_by_team(team_id)
    @games.find_all_by_team(team_id).map do |game|
      if game.away_team_id == team_id
        game.away_goals
      else
        game.home_goals
      end
    end
  end

  def win_loss_hash(team)
    games = {}
    @games.find_all_by_team(team).each do |game|
      if game.home_team_id == team
        games[game.away_team_id] = {wins: 0, losses: 0} unless games[game.away_team_id]
        if game.outcome.include?("home")
          games[game.away_team_id][:wins] += 1
        else
          games[game.away_team_id][:losses] += 1
        end
      else
        games[game.home_team_id] = {wins: 0, losses: 0} unless games[game.home_team_id]
        if game.outcome.include?("away")
          games[game.home_team_id][:wins] += 1
        else
          games[game.home_team_id][:losses] += 1
        end
      end
    end
    return games
  end
end
