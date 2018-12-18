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


end
