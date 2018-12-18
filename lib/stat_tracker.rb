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

  def highest_scoring_visitor
    teams_away_goals = {}
    group_teams_by_away_games.each do |team, games|
      teams_away_goals[team] = calc_average_goals(games)
    end
     highest_team = teams_away_goals.max_by {|team, average_goals| average_goals}
     @teams.find_by_id(highest_team.first).team_name
  end

  def highest_scoring_home_team
    teams_home_goals = {}
    group_teams_by_home_games.each do |team, games|
      teams_home_goals[team] = calc_average_goals(games)
    end
    highest_team = teams_home_goals.max_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def lowest_scoring_visitor
    teams_away_goals = {}
    group_teams_by_away_games.each do |team, games|
      teams_away_goals[team] = calc_average_goals(games)
    end
    highest_team = teams_away_goals.min_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

  def lowest_scoring_home_team
    teams_home_goals = {}
    group_teams_by_home_games.each do |team, games|
      teams_home_goals[team] = calc_average_goals(games)
    end
    highest_team = teams_home_goals.min_by {|team, average_goals| average_goals}
    @teams.find_by_id(highest_team.first).team_name
  end

end
