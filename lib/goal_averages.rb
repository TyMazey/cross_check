module GoalAverages

  def goals_scored_by_team(games = @games.all)
    games.inject(Hash.new(0)) do |goals_by_team_id, game|
      goals_by_team_id[game.away_team_id] += game.away_goals
      goals_by_team_id[game.home_team_id] += game.home_goals
      goals_by_team_id
    end
  end

  def goals_allowed_by_team(games = @games.all)
    games.inject(Hash.new(0)) do |goals_by_team_id, game|
      goals_by_team_id[game.away_team_id] += game.home_goals
      goals_by_team_id[game.home_team_id] += game.away_goals
      goals_by_team_id
    end
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

  def goals_for_visitors
    teams_away_goals = {}
    @games.group_games_by(:away_team_id).each do |team, games|
      teams_away_goals[team] = calc_average_goals(games, false)
    end
    teams_away_goals
  end

  def goals_for_home_teams
    teams_home_goals = {}
    @games.group_games_by(:home_team_id).each do |team, games|
      teams_home_goals[team] = calc_average_goals(games, true)
    end
    teams_home_goals
  end

end
