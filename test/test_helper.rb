require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'capybara/minitest'
require 'pry'
require './app/controller/hockey_site'
require_relative '../lib/stat_tracker'
require_relative '../lib/game'
require_relative '../lib/games'
require_relative '../lib/team'
require_relative '../lib/teams'

Capybara.app = HockeySite
Capybara.save_path = './tmp/capybara'

class CapybaraTestCase < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions
end
