require_relative 'test_helper'

class TeamsTest < Minitest::Test

  def setup
    @attributes = {team_id: "1",
                  franchiseid: "23",
                  shortname: "New Jersey",
                  teamname: "Devils",
                  abbreviation: "NJD",
                  link: "/api/v1/teams/1"}
    @teams = Teams.new
  end

  def test_it_exists
    assert_instance_of Teams, @teams
  end

  def test_it_can_create_new_teams
    @teams.create(@attributes)

    assert_equal "1", @teams.all.first.id
  end

  def test_it_can_find_teams_by_id
    @teams.create(@attributes)

    assert_equal "Devils", @teams.find_by_id("1").team_name
    assert_nil @teams.find_by_id("32")
  end

  def test_it_can_find_teams_by_franchise_id
    @teams.create(@attributes)

    assert_equal "Devils", @teams.find_by_franchise_id("23").team_name
    assert_nil @teams.find_by_franchise_id("32")
  end
end
