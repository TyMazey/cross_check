module CSVReader

  def from_csv(locations)
    load_games(locations[:games]) if locations[:games]
    load_teams(locations[:teams]) if locations[:teams]
    load_game_teams(locations[:game_teams]) if locations[:game_teams]
    return self
  end

  def generate_lines_from_CSV(file_path)
    file = File.new(file_path)
    csv = CSV.new(file, headers: true, header_converters: :symbol)
    csv.read
  end

  def load_games(file_path)
    games_info = generate_lines_from_CSV(file_path)
    games_info.each do |game|
      @games.create(game)
    end
  end

  def load_teams(file_path)
    teams_info = generate_lines_from_CSV(file_path)
    teams_info.each do |team|
      @teams.create(team)
    end
  end

end
