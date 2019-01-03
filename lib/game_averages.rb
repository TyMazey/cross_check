module GameAverages

  def calc_home_win_percentages(id, games)
    home_wins = 0
    home_games = 0
    games.each do |game|
      if game.home_team_id == id
        home_wins += 1 if game.outcome.include?("home")
        home_games += 1
      end
    end
    return (home_wins.to_f / home_games * 100).round(2) unless home_games == 0
    return 0.0
  end

  def calc_away_win_percentages(id, games)
    away_wins = 0
    away_games = 0
    games.each do |game|
      if game.away_team_id == id
        away_wins += 1 if game.outcome.include?("away")
        away_games += 1
      end
    end
    return (away_wins.to_f / away_games * 100).round(2) unless away_games == 0
    return 0.0
  end

  def calculate_win_percentage(id, games)
    wins = games.count do |game|
      (game.outcome.include?("home") && game.home_team_id == id) ||
      (game.outcome.include?("away") && game.away_team_id == id)
    end.to_f
    return (wins / games.count).round(2) unless games.count == 0
    return 0.0
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

  def win_loss_record(team)
    grouped_games = {}
    @games.find_all_by_team(team).each do |game|
      grouped_games[game.home_team_id] = [] unless grouped_games[game.home_team_id]
      grouped_games[game.away_team_id] = [] unless grouped_games[game.away_team_id]
      grouped_games[game.home_team_id] << game
      grouped_games[game.away_team_id] << game
    end
    grouped_games.delete(team)
    final = {}
    grouped_games.each do |current, games|
      final[@teams.find_by_id(current).team_name] = calculate_win_percentage(team, games)
    end
    return final
  end
end
