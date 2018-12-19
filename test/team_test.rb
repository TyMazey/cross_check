require_relative 'test_helper'

class TeamTest < Minitest::Test

  def setup
    attributes = {team_id: "1",
                  franchiseid: "23",
                  shortname: "New Jersey",
                  teamname: "Devils",
                  abbreviation: "NJD",
                  link: "/api/v1/teams/1"}
    @team = Team.new(attributes)
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_an_id
    assert_equal 1, @team.id
  end

  def test_it_has_a_franchise_id
    assert_equal 23, @team.franchise_id
  end

  def test_it_has_a_short_name
    assert_equal "New Jersey", @team.short_name
  end

  def test_it_has_a_team_name
    assert_equal "Devils", @team.team_name
  end

  def test_it_has_an_abbreviation
    assert_equal "NJD", @team.abbreviation
  end

  def test_it_has_a_link
    assert_equal "/api/v1/teams/1", @team.link
  end

  def test_it_can_return_all_attributes
    expected =   {team_id: 1,
                  franchiseId: 23,
                  shortName: "New Jersey",
                  teamName: "Devils",
                  abbreviation: "NJD",
                  link: "/api/v1/teams/1"}

    assert_equal expected, @team.information
  end

end
