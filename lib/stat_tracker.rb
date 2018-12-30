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

  # attr_reader :games,
  #             :teams

  def initialize
    @games = Games.new
    @teams = Teams.new
  end

  def self.from_csv(locations)
    stat_tracker = self.new
    stat_tracker.from_csv(locations)
  end

  def highest_scoring_visitor
    LeagueStatistics.highest_scoring_visitor
    # OR
    SomeOtherLibrary.same_result_through_a_different_method
  end

end
