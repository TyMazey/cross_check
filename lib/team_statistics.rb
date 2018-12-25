module TeamStatistics

  def team_info(id)
    @teams.find_by_id(id).information
  end

  def best_season(team_id)
    games_by_season = {
      team_id => @games.group_games_by(:season, @games.find_all_by_team(team_id))
    }
    season_win_percentage = batch_map_hash_to_win_percentage(games_by_season)
    max = season_win_percentage[team_id].max_by {|season, percentage| percentage}
    return max.first
  end

  def worst_season(team_id)
    games_by_season = {
      team_id => @games.group_games_by(:season, @games.find_all_by_team(team_id))
    }
    season_win_percentage = batch_map_hash_to_win_percentage(games_by_season)
    min = season_win_percentage[team_id].min_by {|season, percentage| percentage}
    return min.first
  end

  def average_win_percentage(team_id)
    games_by_season = {
      team_id => @games.group_games_by(:season, @games.find_all_by_team(team_id))
    }
    season_win_percentage = batch_map_hash_to_win_percentage(games_by_season)[team_id]
    total = season_win_percentage.sum do |season, win_percentage|
      win_percentage
    end
    season_count = season_win_percentage.count
    return (total / season_count).round(2) unless season_count == 0
    return 0.0
  end

  def most_goals_scored(team_id)
    collection_of_goals_scored_by_team(team_id).max
  end

  def fewest_goals_scored(team_id)
    collection_of_goals_scored_by_team(team_id).min
  end

  def favorite_opponent(team_id)
    team_history = win_loss_record(team_id)
    highest_percentage = team_history.max_by do |opponent, history|
      history[:wins].to_f / history[:losses] * 100.0
    end
    @teams.find_by_id(highest_percentage.first).team_name
  end

  def rival(team_id)
    team_history = win_loss_record(team_id)
    lowest_percentage = team_history.min_by do |opponent, history|
      history[:wins].to_f / history[:losses] * 100.0
    end
    @teams.find_by_id(lowest_percentage.first).team_name
  end

  def biggest_team_blowout(id)
    biggest_blowout(@games.find_wins_by_team(id))
  end

  def worst_loss(id)
    biggest_blowout(@games.find_losses_by_team(id))
  end

  def head_to_head(team, team_against)
    win_loss_record(team)[team_against]
  end

  def win_loss_record(team)
    games = {}
    @games.find_all_by_team(team).each do |game|
      if game.home_team_id == team
        games[game.away_team_id] = {wins: 0, losses: 0} unless games[game.away_team_id]
        if game.outcome.include?("home")
          games[game.away_team_id][:wins] += 1
        else
          games[game.away_team_id][:losses] += 1
        end
      else
        games[game.home_team_id] = {wins: 0, losses: 0} unless games[game.home_team_id]
        if game.outcome.include?("away")
          games[game.home_team_id][:wins] += 1
        else
          games[game.home_team_id][:losses] += 1
        end
      end
    end
    return games
  end

end