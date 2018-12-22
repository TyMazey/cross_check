require_relative './average_goals'

module GameStatistics
  include AverageGoals

  def highest_total_score
    @games.get_total_scores(@games.all).max
  end

  def lowest_total_score
    @games.get_total_scores(@games.all).min
  end

  def biggest_blowout(games = @games.all)
    calc_blowout(games.max_by {|game| calc_blowout(game)})
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
    calc_wins("home")
  end

  def percentage_visitor_wins
    calc_wins("away")
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

  def count_of_games_by_season
    seasons = @games.group_games_by(:season)
    seasons.each do |season, games|
       seasons[season] = games.count
    end
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
end
