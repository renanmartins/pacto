require 'webrick'

class Servlet < WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, json)
    super(server)
    @json = json
  end

  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = @json
  end
end

class DummyServer
  def initialize port, path, response
    @server = WEBrick::HTTPServer.new :Port => port,
      :AccessLog => [],
      :Logger => WEBrick::Log::new("/dev/null", 7)
    @server.mount path, Servlet, response
  end

  def start
    @pid = Thread.new do
      trap 'INT' do @server.shutdown end
      @server.start
    end
  end

  def terminate
    @pid.kill
  end
end
