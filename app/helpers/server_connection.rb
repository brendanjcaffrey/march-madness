require 'socket'

class ServerConnection
	def connect
		server = TCPServer.open(2000)   
		@client = server.accept
	end

	def sendTeams(team1,team2)
		@client.puts(team1 + ":" + team2 + "\r\n");
	end

	def getWinner
		@client.gets.gsub(/.+:|\r\n+/,'')
	end
end

