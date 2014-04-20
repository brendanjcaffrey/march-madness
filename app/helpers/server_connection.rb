require 'socket'

class ServerConnection
	def connect
		server = TCPServer.open(2000)   
		@client = server.accept
	end

	def sendTeams(teams)
		@client.puts(teams.join(":") + "\r\n");
	end

	def getRanking
		@client.gets.split(/:|\r\n/)
	end
end

