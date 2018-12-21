require 'csv'
require_relative './games'
require_relative './teams'
require_relative './csv_reader'

class StatTracker
  include CSVReader

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

  def highest_total_score
    @games.get_total_scores(@games.all).max
  end

  def lowest_total_score
    @games.get_total_scores(@games.all).min
  end

  def calc_blowout(game)
    (game.home_goals - game.away_goals).abs
  end

  def biggest_blowout(games = @games.all)
    calc_blowout(games.max_by {|game| calc_blowout(game)})
  end

  def calc_wins(where)
    wins = @games.all.find_all do |game|
      game.outcome.include?(where)
    end
    ((wins.count.to_f / @games.all.count) * 100.0).round(2)
  end

  def calc_home_win_percentages(id, games)
    home_wins = games.count do |game|
      game.outcome.include?("home") && game.home_team_id == id
    end
      return (home_wins.to_f / games.count * 100) unless games.count == 0
      return 0.0
  end

  def calc_away_win_percentages(id, games)
    away_wins = games.count do |game|
      game.outcome.include?("away") && game.home_team_id == id
    end
      return (away_wins.to_f / games.count * 100) unless games.count == 0
      return 0.0
  end

  def calculate_win_percentage(id, games)
    wins = calc_home_win_percentages(id, games) + calc_away_win_percentages(id, games) / 2
    return wins
  end

  def percentage_home_wins
    home = "home win"
    calc_wins(home)
  end

  def percentage_away_wins
    away = "away win"
    calc_wins(away)
  end

  def most_popular_venue
    top_venue = @games.group_games_by(:venue).max_by do |venue, games|
      games.count
    end
    top_venue.first
  end

  def least_popular_venue
    bottom_venue = @games.group_games_by(:venue).min_by do |venue, games|
      games.count
    end
    bottom_venue.first
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

  def season_with_most_games
    @games.group_games_by(:season).max_by do |season, games|
      games.count
    end.first
  end

  def season_with_least_games
    @games.group_games_by(:season).min_by do |season, games|
      games.count
    end.first
  end

  def average_goals_per_game(games = @games.all)
    (@games.get_total_scores(games).sum.to_f / games.count).round(2)
  end

  def average_goals_by_season
    seasons = @games.group_games_by(:season)
    seasons.each do |season, games|
      seasons[season] = average_goals_per_game(games)
    end
    seasons
  end

  def count_of_games_by_season
    seasons = @games.group_games_by(:season)
    seasons.each do |season, games|
       seasons[season] = games.count
    end
  end

  # def group_teams_by_away_games
  #   grouped_values = {}
  #   @teams.all.each do |team|
  #     grouped_values[team.id] = @games.find_all_by_away_team_id(team.id)
  #   end
  #   grouped_values
  # end
  #
  # def group_teams_by_home_games
  #   grouped_values = {}
  #   @teams.all.each do |team|
  #     grouped_values[team.id] = @games.find_all_by_home_team_id(team.id)
  #   end
  #   grouped_values
  # end

  def calc_average_goals(games)
    if games.count != 0
    games.sum {|game| game.away_goals} / games.count
    else
      0
    end
  end

  def highest_scoring_visitor
    teams_away_goals = {}
    @games.group_games_by(:away_team_id).each do |team, games|
      teams_away_goals[team] = calc_average_goals(games)
    end
     highest_team = teams_away_goals.max_by {|team, average_goals| average_goals}
     @teams.find_by_id(highest_team.first).team_name
  end

  def highest_scoring_home_team
    teams_home_goals = {}
    @games.group_games_by(:home_team_id).each do |team, games|
      teams_home_goals[team] = calc_average_goals(games)
    end
    highest_team = teams_home_goals.max_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def lowest_scoring_visitor
    teams_away_goals = {}
    @games.group_games_by(:away_team_id).each do |team, games|
      teams_away_goals[team] = calc_average_goals(games)
    end
    highest_team = teams_away_goals.min_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def lowest_scoring_home_team
    teams_home_goals = {}
    @games.group_games_by(:home_team_id).each do |team, games|
      teams_home_goals[team] = calc_average_goals(games)
    end
    highest_team = teams_home_goals.min_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def count_of_teams
    @teams.all.count
  end

  def goals_scored_by_team
    @games.all.inject(Hash.new(0)) do |goals_by_team_id, game|
      goals_by_team_id[game.away_team_id] += game.away_goals
      goals_by_team_id[game.home_team_id] += game.home_goals
      goals_by_team_id
    end
  end

  def goals_allowed_by_team
    @games.all.inject(Hash.new(0)) do |goals_by_team_id, game|
      goals_by_team_id[game.away_team_id] += game.home_goals
      goals_by_team_id[game.home_team_id] += game.away_goals
      goals_by_team_id
    end
  end

  def best_offense
    highest_scoring = goals_scored_by_team.max_by do |team_id, total_goals|
      total_goals
    end

    @teams.find_by_id(highest_scoring.first).team_name
  end

  def worst_offense
    lowest_scoring = goals_scored_by_team.min_by do |team_id, total_goals|
      total_goals
    end

    @teams.find_by_id(lowest_scoring.first).team_name
  end

  def best_defense
    least_allowed = goals_allowed_by_team.min_by do |team_id, total_goals|
      total_goals
    end

    @teams.find_by_id(least_allowed.first).team_name
  end

  def worst_defense
    most_allowed = goals_allowed_by_team.max_by do |team_id, total_goals|
      total_goals
    end

    @teams.find_by_id(most_allowed.first).team_name
  end

  def winningest_team
    team_games = group_games_by_team
    team_games.each do |team_id, games|
      team_games[team_id] = calculate_win_percentage(team_id, games)
    end
    @teams.find_by_id((team_games.max_by {|team, goals| goals}).first).team_name
  end

  def season_summary(season, team_id)
    summary = @games.group_games_by(:season, @games.find_all_by_team(team_id))[season]
    summary = @games.group_games_by(:type, summary)
    generate_season_summary(summary, team_id)
  end

  def generate_season_summary(grouped_games, team_id)
    final_summary = Hash.new({})
    final_summary[:preseason] = generate_summary(grouped_games["P"], team_id)
    final_summary[:regular_season] = generate_summary(grouped_games["R"], team_id)
    final_summary
  end

  def generate_summary(selection, team_id)
    summary = {}
    if selection
      summary[:win_percentage] = calculate_win_percentage(team_id, selection)
      summary[:goals_scored] = goals_scored_by_team_in_selection(team_id, selection)
      summary[:goals_against] = goals_allowed_by_team_in_selection(team_id, selection)
    else
      summary[:win_percentage] = 0.0
      summary[:goals_scored] = 0
      summary[:goals_against] = 0
    end
    return summary
  end

  def goals_scored_by_team_in_selection(team_id, selection)
    selection.sum do |game|
      if game.home_team_id == team_id
        game.home_goals
      else
        game.away_goals
      end
    end
  end

  def goals_allowed_by_team_in_selection(team_id, selection)
    selection.sum do |game|
      if game.home_team_id == team_id
        game.away_goals
      else
        game.home_goals
      end
    end
  end

  def get_win_ratios_by_season(season)
    games_in_season = @games.find_by_season_id(season)
    games_by_team = group_selected_games_by_team(games_in_season)
    grouped_games_by_type = group_team_games_by_type(games_by_team)
    batch_map_hash_to_win_percentage(grouped_games_by_type)
  end

  def biggest_bust(season)
    win_ratios = get_win_ratios_by_season(season)
    loser = win_ratios.max_by do |team_id, season_type|
      (win_ratios[team_id]["P"] - win_ratios[team_id]["R"])
    end
    @teams.find_by_id(loser.first).team_name
  end

  def biggest_surprise(season)
    win_ratios = get_win_ratios_by_season(season)
    winner = win_ratios.min_by do |team_id, season_type|
      win_ratios[team_id]["P"] - win_ratios[team_id]["R"]
    end
    @teams.find_by_id(winner.first).team_name
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
      final[team_id] = games.group_by {|game| game.type}
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

  def best_fans
    teams_wins = {}
    @teams.all.each do |team|
      teams_wins[team] = calc_home_win_percentages(team.id, @games.all) - calc_away_win_percentages(team.id, @games.all)
    end
    best_fans = teams_wins.max_by do |team, percentages|
      percentages
    end
    best_fans.first.team_name
  end

  def worst_fans
    teams_wins = {}
    @teams.all.each do |team|
      teams_wins[team] = calc_home_win_percentages(team.id, @games.all) - calc_away_win_percentages(team.id, @games.all)
    end
    worst_fans = teams_wins.find_all do |team, percentages|
      percentages < 50
    end
    worst_fans.map {|team| team.first.team_name}
  end

  def team_info(id)
    @teams.find_by_id(id).information
  end

  def map_season_hash_to_win_percentage(team_id, games_by_season)
    games_by_season.each do |season, games|
      games_by_season[season] = calculate_win_percentage(team_id, games)
    end
    games_by_season
  end

  def best_season(team_id)
    games_by_season = group_games_of_team_by_season(team_id)
    season_win_percentage = map_season_hash_to_win_percentage(team_id, games_by_season)
    max = season_win_percentage.max_by {|season, percentage| percentage}
    return max.first
  end

  def worst_season(team_id)
    games_by_season = group_games_of_team_by_season(team_id)
    season_win_percentage = map_season_hash_to_win_percentage(team_id, games_by_season)
    min = season_win_percentage.min_by {|season, percentage| percentage}
    return min.first
  end

  def group_games_of_team_by_season(team_id)
     games_for_team = @games.find_all_by_home_team_id(team_id)
     games_for_team += @games.find_all_by_away_team_id(team_id)
     games_for_team.group_by do |game|
       game.season
     end
  end

  def biggest_team_blowout(id)
    biggest_blowout(@games.find_wins_by_team(id))
  end

  def worst_loss(id)
    biggest_blowout(@games.find_losses_by_team(id))
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

  def most_goals(team_id)
    collection_of_goals_scored_by_team(team_id).max
  end

  def fewest_goals(team_id)
    collection_of_goals_scored_by_team(team_id).min
  end

  def favorite_team(team_id)
    team_history = win_loss_hash(team_id)
    highest_percentage = team_history.max_by do |opponent, history|
      history[:wins].to_f / history[:losses] * 100.0
    end
    @teams.find_by_id(highest_percentage.first).team_name
  end

  def rival(team_id)
    team_history = win_loss_hash(team_id)
    lowest_percentage = team_history.min_by do |opponent, history|
      history[:wins].to_f / history[:losses] * 100.0
    end
    @teams.find_by_id(lowest_percentage.first).team_name
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

  def head_to_head(team, team_against)
    win_loss_hash(team)[team_against]
  end

  def seasonal_summary(team_id)
    generate_multi_season_summary(team_id)
  end

  def generate_multi_season_summary(team_id)
    summary = {}
    all_seasons = @games.all_seasons_for_team(team_id)
    all_seasons.each do |season|
      summary[season] = season_summary(season, team_id)
    end
    populate_missing_info(team_id, summary)
  end

  def populate_missing_info(team_id, summary)
    summary.each do |season, generated_summary|
      grouped_games = @games.group_games_by(:season, @games.find_all_by_team(team_id))[season]
      grouped_games = @games.group_games_by(:type, grouped_games)
      grouped_games.default=([]) # Override default to allow count
      generated_summary.each do |type, stats|
        game_count = grouped_games[type.to_s.capitalize[0]].count
        if game_count == 0
          stats[:average_goals_scored] = 0.0
          stats[:average_goals_against] = 0.0
        else
          stats[:average_goals_scored] = stats[:goals_scored].to_f / game_count
          stats[:average_goals_against] = stats[:goals_against].to_f / game_count
        end
      end
    end
    return summary
  end

end
