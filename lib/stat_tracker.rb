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
    csv = CSV.new(file)
    lines = csv.read
    headers = headers_to_sym(lines.delete_at(0))
    game_hashes = lines.map do |line|
      headers.zip(line).to_h
    end
  end

  def headers_to_sym(headers)
    headers.map do |header|
      header.to_sym
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
    binding.pry
  end




end
