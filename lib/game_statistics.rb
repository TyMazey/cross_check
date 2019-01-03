require_relative './game_averages'
require_relative './goal_averages'

module GameStatistics
  include GameAverages,
          GoalAverages

  def highest_total_score
    get_total_scores(@games.all).max
  end

  def lowest_total_score
    get_total_scores(@games.all).min
  end

  def biggest_blowout(games = @games.all)
    (games.max_by {|game| game.calc_blowout}).calc_blowout
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

  def percentage_home_wins
    win_count = @games.all.count {|game| game.outcome.include?("home")}.to_f
    (win_count / @games.all.count).round(2)
  end

  def percentage_visitor_wins
    win_count = @games.all.count {|game| game.outcome.include?("away")}.to_f
    (win_count / @games.all.count).round(2)
  end

  def season_with_most_games
    @games.group_games_by(:season).max_by do |season, games|
      games.count
    end.first.to_i
  end

  def season_with_fewest_games
    @games.group_games_by(:season).min_by do |season, games|
      games.count
    end.first.to_i
  end

  def count_of_games_by_season
    seasons = @games.group_games_by(:season)
    seasons.each do |season, games|
       seasons[season] = games.count
    end
  end

  def average_goals_per_game(games = @games.all)
    (get_total_scores(games).sum.to_f / games.count).round(2)
  end

  def average_goals_by_season
    seasons = @games.group_games_by(:season)
    seasons.each do |season, games|
      seasons[season] = average_goals_per_game(games)
    end
    seasons
  end
end
