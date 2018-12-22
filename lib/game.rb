class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :outcome,
              :venue

  def initialize(attributes)
    @game_id = attributes[:game_id].to_i
    @season = attributes[:season].to_i
    @type = attributes[:type]
    @date_time = attributes[:date_time]
    @away_team_id = attributes[:away_team_id].to_i
    @home_team_id = attributes[:home_team_id].to_i
    @away_goals = attributes[:away_goals].to_i
    @home_goals = attributes[:home_goals].to_i
    @outcome = attributes[:outcome]
    @venue = attributes[:venue]
  end


  def calc_blowout
    (@home_goals - @away_goals).abs
  end

end
