require 'socket'

class ServerConnection
	def connect
		server = TCPServer.open(2000)   
		@client = server.accept
	end

	def send(message)
		@client.puts(message + "\r\n\r\n");
	end

	def get
		@client.gets
	end
end

