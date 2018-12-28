require 'rack'

class HockeySite
  def self.call(env)
    path = env["PATH_INFO"]
    if path == '/'
      index
    elsif File.exist?("./app/views/#{path}.html")
      path
    else error
    end
  end

  def self.index
    render_view('index.html')
  end

  def self.error
    render_view('error.html', '404')
  end

  def self.render_view(page, code = '200')
    [code, {'Content-Type' => 'text/html'}, [File.read("./app/views/#{page}")]]
  end
end
