module GameAverages

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

  def get_win_ratios_by_season(season)
    games_in_season = @games.find_by_season_id(season)
    games_by_team = @games.group_games_by_team(games_in_season)
    games_by_team.each do |team_id, games|
      games_by_team[team_id] = @games.group_games_by(:type, games)
    end
    batch_map_hash_to_win_percentage(games_by_team)
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
end
