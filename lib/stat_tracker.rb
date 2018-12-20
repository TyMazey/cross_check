require 'csv'
require_relative './games'
require_relative './teams'

class StatTracker

  attr_reader :games,
              :teams

  def initialize
    @games = Games.new
    @teams = Teams.new
  end

  def self.from_csv(locations)
    stat_tracker = StatTracker.new
    stat_tracker.load_games(locations[:games]) if locations[:games]
    stat_tracker.load_teams(locations[:teams]) if locations[:teams]
    stat_tracker.load_game_teams(locations[:game_teams]) if locations[:game_teams]
    return stat_tracker
  end

  def generate_hash_from_CSV(file_path)
    file = File.new(file_path)
    csv = CSV.new(file, headers: true, header_converters: :symbol)
    lines = csv.read
    lines.map do |line|
      line.to_h
    end
  end

  def load_games(file_path)
    games_info = generate_hash_from_CSV(file_path)
    games_info.each do |game|
      @games.create(game)
    end
  end

  def load_teams(file_path)
    teams_info = generate_hash_from_CSV(file_path)
    teams_info.each do |team|
      @teams.create(team)
    end
  end

  def get_total_scores(games)
    games.map do |game|
      game.away_goals + game.home_goals
    end
  end

  def highest_total_score
    get_total_scores(@games.all).max
  end

  def lowest_total_score
    get_total_scores(@games.all).min
  end

  def calc_blowout(game)
    (game.home_goals - game.away_goals).abs
  end

  def biggest_blowout
    highest_blowout = @games.all.max_by do |game|
      calc_blowout(game)
    end
    calc_blowout(highest_blowout)
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
    top_venue = group_games_by_venue.max_by do |venue, games|
      games.count
    end
    top_venue.first
  end

  def least_popular_venue
    bottom_venue = group_games_by_venue.min_by do |venue, games|
      games.count
    end
    bottom_venue.first
  end

  def group_games_by_venue
    @games.all.group_by do |game|
      game.venue
    end
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
    season = group_games_by_season.max_by do |season, games|
      games.count
    end
    season.first
  end

  def season_with_least_games
    season = group_games_by_season.min_by do |season, games|
      games.count
    end
    season.first
  end

  def average_goals_per_game
    (get_total_scores(@games.all).sum.to_f / @games.all.count).round(2)
  end

  def average_goals_by_season
    seasons = group_games_by_season
    seasons.each do |season, games|
      seasons[season] = (get_total_scores(games).sum.to_f / games.count).round(2)
    end
    seasons
  end

  def count_of_games_by_season
    seasons = group_games_by_season
    seasons.each do |season, games|
       seasons[season] = games.count
    end
  end

  def group_games_by_season
    @games.all.group_by do |game|
      game.season
    end
  end

  def group_teams_by_away_games
    grouped_values = {}
    @teams.all.each do |team|
      grouped_values[team.id] = @games.find_all_by_away_team_id(team.id)
    end
    grouped_values
  end

  def group_teams_by_home_games
    grouped_values = {}
    @teams.all.each do |team|
      grouped_values[team.id] = @games.find_all_by_home_team_id(team.id)
    end
    grouped_values
  end

  def calc_average_goals(games)
    if games.count != 0
    games.sum {|game| game.away_goals} / games.count
    else
      0
    end
  end

  def goals_for_visitors
    teams_away_goals = {}
    group_teams_by_away_games.each do |team, games|
      teams_away_goals[team] = calc_average_goals(games)
    end
    teams_away_goals
  end

  def goals_for_home_teams
    teams_home_goals = {}
    group_teams_by_home_games.each do |team, games|
      teams_home_goals[team] = calc_average_goals(games)
    end
    teams_home_goals
  end

  def highest_scoring_visitor
    teams_away_goals = goals_for_visitors
     highest_team = teams_away_goals.max_by {|team, average_goals| average_goals}
     @teams.find_by_id(highest_team.first).team_name
  end

  def highest_scoring_home_team
    teams_home_goals = goals_for_home_teams
    highest_team = teams_home_goals.max_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def lowest_scoring_visitor
    teams_away_goals = goals_for_visitors
    highest_team = teams_away_goals.min_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def lowest_scoring_home_team
    teams_home_goals = goals_for_home_teams
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
    summary = group_games_by_season_type(season, team_id)
    generate_season_summary(summary, team_id)
  end

  def group_games_by_season_type(season, team_id)
    all_games_in_season = @games.find_by_season_id(season)
    games_for_team = all_games_in_selection_for_team(team_id, all_games_in_season)
    games_for_team.group_by {|game| game.type}
  end

  def all_games_in_selection_for_team(team, selection)
    selection.find_all do |game|
      game.home_team_id == team || game.away_team_id == team
    end
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
     test = games_for_team.group_by do |game|
       game.season
     end
  end

  def biggest_team_blowout(id)
    biggest_win = @games.find_wins_by_team(id).max_by do |game|
      calc_blowout(game)
    end
    calc_blowout(biggest_win)
  end

  # Refactor these methods && biggest_blowout to use generic

  def worst_loss(id)
    biggest_loss = @games.find_losses_by_team(id).max_by do |game|
      calc_blowout(game)
    end
    calc_blowout(biggest_loss)
  end

  def collection_of_goals_scored_by_team(team_id)
    teams_games = group_games_by_team[team_id]
    goals = teams_games.map do |game|
      if game.away_team_id == team_id
        game.away_goals
      else
        game.home_goals
      end
    end
    goals
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

  # def win_loss_records(team)
  #   win_loss = {}
  #   @teams.all.each do |team|
  #     win_loss[team.id] = {wins: @games.find_wins_by_team(team.id).count},
  #                     {losses: @games.find_losses_by_team(team.id).count}
  #   end
  #   binding.pry
  # end

  def win_loss_hash(team)
    games = {}
    @games.find_all_games_by_team(team).each do |game|
      if game.home_team_id == team
        if game.outcome.include?("home")
          games[game.away_team_id] = {wins: 0, losses: 0} unless games[game.away_team_id]
          games[game.away_team_id][:wins] += 1
        else
          games[game.away_team_id] = {wins: 0, losses: 0} unless games[game.away_team_id]
          games[game.away_team_id][:losses] += 1
        end
      else
        if game.outcome.include?("away")
          games[game.home_team_id] = {wins: 0, losses: 0} unless games[game.home_team_id]
          games[game.home_team_id][:wins] += 1
        else
          games[game.home_team_id] = {wins: 0, losses: 0} unless games[game.home_team_id]
          games[game.home_team_id][:losses] += 1
        end
      end
    end
    return games
  end

  def head_to_head(team, team_against)
    win_loss_hash(team)[team_against]
  end
end
