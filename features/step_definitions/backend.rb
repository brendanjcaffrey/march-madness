Given(/^the backend is connected$/) do
  p 'Start the backend tests now, waiting...'
  @queue = ServerConnection.new
  @queue.connect
end

When(/^"(.+)" are sent to the backend$/) do |teams|
  teams = teams.split(",")
  @queue.sendTeams(teams)
end

Then(/^it should return "(.+)"$/) do |teams|
  teams = teams.split(",")
  matching = teams.zip(@queue.getRanking)
  matching.each{|x,y| expect(x).to eq(y)}
end

