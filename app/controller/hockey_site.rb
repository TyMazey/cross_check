require 'rack'

class HockeySite
  def self.call(env)
    path = env["PATH_INFO"]
    if path == '/'
      index
    elsif File.exist?("./app/views/#{path}.html")
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

  def self.about
    render_view('about.html')
  end

  def self.render_view(page, code = '200')
    [code, {'Content-Type' => 'text/html'}, [File.read("./app/views#{page}.html")]]
  end

  def self.render_style(page, code = '200')
    [code, {'Content-Type' => 'text/css'}, [File.read("./app/views#{page}")]]
  end
end
