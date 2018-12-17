require './lib/stat_tracker'

game_path = './data/game_test.csv'
team_path = './data/team_info_test.csv'
game_teams_path = './data/game_teams_stats_test.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)

require 'pry'; binding.pry
