require 'csv'

class StatTracker

  attr_reader :game_info,
              :game_team_info,
              :team_info

  def initialize
    @games = Games.new
    @teams = Teams.new
  end

  def self.from_csv(locations)
    stat_tracker = StatTracker.new
    load_games(locations, stat_tracker) if locations[:games]
    load_teams(locations, stat_tracker) if locations[:teams]
    load_game_teams(locations, stat_tracker) if locations[:game_teams]
    return stat_tracker
  end

  def generate_hash_from_CSV(file)
    csv = CSV.new(file)
    lines = csv.read
    headers = headers_to_sym(lines.delete_at(0))
    game_hashes = lines.map do |line|
      headers.zip(line).to_h
    end
  end


end
