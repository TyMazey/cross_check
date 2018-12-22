module Averages

  def calc_wins(home_away)
    wins = @games.all.find_all do |game|
      game.outcome.include?(home_away)
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
      game.outcome.include?("away") && game.away_team_id == id
    end
      return (away_wins.to_f / games.count * 100) unless games.count == 0
      return 0.0
  end

  def calculate_win_percentage(id, games)
    wins = calc_home_win_percentages(id, games) + calc_away_win_percentages(id, games) / 2
    return wins
  end

  def calc_average_goals(games, home)
    if games.count != 0
      if home
        (games.sum {|game| game.home_goals}.to_f / games.count).round(2)
      else
        (games.sum {|game| game.away_goals}.to_f / games.count).round(2)
      end
    else
      0
    end
  end


end
