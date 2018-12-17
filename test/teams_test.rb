require_relative 'test_helper'

class TeamsTest < Minitest::Test

  def setup
    @attributes = {team_id: "1",
                  franchiseId: "23",
                  shortName: "New Jersey",
                  teamName: "Devils",
                  abbreviation: "NJD",
                  link: "/api/v1/teams/1"}
    @teams = Teams.new
  end

  def test_it_exists
    assert_instance_of Teams, @teams
  end

  def test_it_can_create_new_teams
    @teams.create(@attributes)

    assert_equal 1, @teams.all.first.id
  end

  def test_it_can_find_teams_by_id
    @teams.create(@attributes)

    assert_equal "Devils", @teams.find_by_id(1).team_name
  end

  def test_it_can_find_teams_by_franchise_id
    @teams.create(@attribures)

    assert_equal "Devils", @teams.find_by_franchise_id(23).team_name
  end
end
