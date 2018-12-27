require_relative 'test_helper'
require 'csv'

class CSVReaderTest < Minitest::Test

  def test_it_can_read_lines_from_a_csv
    stat_tracker = StatTracker.new

    actual = stat_tracker.generate_lines_from_CSV('./data/game_test.csv')

    assert_equal 2, actual.count
    actual.each do |row|
      assert_instance_of CSV::Row, row
    end
  end

  def test_it_can_generate_game_objects_from_csv
    stat_tracker = StatTracker.new

    stat_tracker.load_games('./data/game_test.csv')

    assert_equal 2, stat_tracker.games.all.count
    assert_equal 2012030221, stat_tracker.games.all.first.game_id
  end

  def test_it_can_generate_team_objects_from_csv
    stat_tracker = StatTracker.new

    stat_tracker.load_teams('./data/team_info.csv')

    assert_equal 33, stat_tracker.teams.all.count
    assert_equal 1, stat_tracker.teams.all.first.id
    assert_equal "Thrashers", stat_tracker.teams.all.last.team_name
  end

end
