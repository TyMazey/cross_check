module Summaries
  include GameAverages,
          GoalAverages

  def season_summary(season, team_id)
    summary = @games.group_games_by(:season, @games.find_all_by_team(team_id))[season]
    generate_season_summary(summary, team_id, false)
  end

  def seasonal_summary(id)
    seasonal_games = @games.group_games_by(:season, @games.find_all_by_team(id))
    seasonal_games.each do |season, games|
      seasonal_games[season] = generate_season_summary(games, id, true)
    end
    seasonal_games
  end

  def generate_season_summary(games, team_id, additional_info)
    final_summary = Hash.new({})
    games_by_type = @games.group_games_by(:type, games)
    final_summary[:preseason] = generate_summary(games_by_type["P"], team_id, additional_info)
    final_summary[:regular_season] = generate_summary(games_by_type["R"], team_id, additional_info)
    final_summary
  end

  def generate_summary(selection, team_id, additional_statistics)
    summary = {}
    if additional_statistics
      game_count = selection.count
      summary[:win_percentage] = calculate_win_percentage(team_id, selection)
      summary[:total_goals_scored] = goals_scored_by_team(selection)[team_id]
      summary[:total_goals_against] = goals_allowed_by_team(selection)[team_id]
      if game_count == 0
        summary[:average_goals_scored] = 0.0
        summary[:average_goals_against] = 0.0
      else
        summary[:average_goals_scored] = (summary[:total_goals_scored].to_f / game_count).round(2)
        summary[:average_goals_against] = (summary[:total_goals_against].to_f / game_count).round(2)
      end
    else
      summary[:win_percentage] = calculate_win_percentage(team_id, selection)
      summary[:goals_scored] = goals_scored_by_team(selection)[team_id]
      summary[:goals_against] = goals_allowed_by_team(selection)[team_id]
    end
    summary
  end

  def biggest_bust(season)
    win_ratios = get_win_ratios_by_season(season)
    loser = win_ratios.max_by do |team_id, season_type|
      (win_ratios[team_id]["P"] - win_ratios[team_id]["R"])
    end
    @teams.find_by_id(loser.first).team_name
  end

  def biggest_surprise(season)
    win_ratios = get_win_ratios_by_season(season)
    winner = win_ratios.min_by do |team_id, season_type|
      win_ratios[team_id]["P"] - win_ratios[team_id]["R"]
    end
    @teams.find_by_id(winner.first).team_name
  end
end
