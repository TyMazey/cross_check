require_relative 'test_helper'

class StatTrackerTest < Minitest::Test

  def setup
    @stat_tracker = StatTracker.new
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

end
