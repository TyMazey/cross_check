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
    return max.first if max
    return nil
  end

  def worst_season(team_id)
    games_by_season = {
      team_id => @games.group_games_by(:season, @games.find_all_by_team(team_id))
    }
    season_win_percentage = batch_map_hash_to_win_percentage(games_by_season)
    min = season_win_percentage[team_id].min_by {|season, percentage| percentage}
    return min.first if min
    return nil
  end

  def average_win_percentage(team_id)
    calculate_win_percentage(team_id, @games.find_all_by_team(team_id))
    # games_by_season = {
    #   team_id => @games.group_games_by(:season, @games.find_all_by_team(team_id))
    # }
    # season_win_percentage = batch_map_hash_to_win_percentage(games_by_season)[team_id]
    # total = season_win_percentage.sum do |season, win_percentage|
    #   win_percentage
    # end
    # season_count = season_win_percentage.count
    # require 'pry';binding.pry
    # return (total / season_count).round(2) unless season_count == 0
    # return 0.0
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
      history
    end
    highest_percentage.first
  end

  def rival(team_id)
    team_history = win_loss_record(team_id)
    lowest_percentage = team_history.min_by do |opponent, history|
      history
    end
    lowest_percentage.first
  end

  def biggest_team_blowout(id)
    biggest_blowout(@games.find_wins_by_team(id))
  end

  def worst_loss(id)
    biggest_blowout(@games.find_losses_by_team(id))
  end

  def head_to_head(team)
    win_loss_record(team)
  end
end
