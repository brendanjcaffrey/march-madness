Given(/^the backend is connected$/) do
  p 'Start the backend tests now, waiting...'
  @queue = ServerConnection.new
  @queue.connect
  #@queue = nil
end

When(/^"(.+)" and "(.+)" are sent to the backend$/) do |team1, team2|
  @queue.sendTeams(team1, team2)
end

Then(/^it should return "(.+)"$/) do |team|
  expect(@queue.getWinner).to eq(team)
end

