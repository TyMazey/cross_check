require 'rack'

class HockeySite
  def self.call(env)
    ['200', {'Content-Type' => 'text/html'}, [File.read('./app/views/index.html')]]
  end
end
