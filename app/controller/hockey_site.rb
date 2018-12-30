require 'rack'
require './lib/stat_tracker'
require 'erb'

class HockeySite
  @@stat_tracker = StatTracker.from_csv(games: "./data/game.csv",
                 teams: "./data/team_info.csv")

  @@league_state_view = {
    highest_scoring_home_team: set_the_team_name_from_a_helper_method
  }
  def self.call(env)
    path = env["PATH_INFO"]
    # require 'pry'; binding.pry
    @@query = env["QUERY_STRING"].split("&").map{|x|x.split("=")}.to_h
    if path == '/'
      index
    elsif File.exist?("./app/views#{path}.html.erb")
      render_view(path)
    elsif File.exist?("./app/views/#{path}")
      render_style(path)
    else error
    end
  end

  def self.index
    render_view('/index')
  end

  def self.error
    render_view('/error', '404')
  end

  def self.render_view(page, code = '200')
    renderer = ERB.new(File.read("./app/views#{page}.html.erb"))
    rendered_page = renderer.result(get_binding)
    [code, {'Content-Type' => 'text/html'}, [rendered_page]]
  end

  def self.render_style(page, code = '200')
    [code, {'Content-Type' => 'text/css'}, [File.read("./app/views#{page}")]]
  end

  def self.get_binding
    binding
  end
end
