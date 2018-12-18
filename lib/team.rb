class Team

  attr_reader :id,
              :franchise_id,
              :short_name,
              :team_name,
              :abbreviation,
              :link

  def initialize(attributes)
    @id = attributes[:team_id].to_i
    @franchise_id = attributes[:franchiseid].to_i
    @short_name = attributes[:shortname]
    @team_name = attributes[:teamname]
    @abbreviation = attributes[:abbreviation]
    @link = attributes[:link]
  end
end
