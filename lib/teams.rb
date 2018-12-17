require_relative './team'

class Teams

  def initialize
    @teams = []
  end

  def create(attributes)
    @teams << Team.new(attributes)
  end

  def all
    @teams
  end

  def find_by_id(id)
    @teams.find do |team|
      team.id == id
    end
  end

  def find_by_franchise_id(id)
    @teams.find do |team|
      team.franchise_id == id
    end
  end

end
