require 'spec_helper'
require 'rake'
require "#{Rails.root}/app/helpers/server_connection"

describe 'server connection' do
  it 'it should connect to the client' do
  
  queue = ServerConnection.new
  puts 'server awaiting client..'
  queue.connect
  
  queue.sendTeams('illinois','michigan')
  message = queue.getWinner
  expect(message).to eq("illinois")

  queue.sendTeams('illinois','san jose')
  message = queue.getWinner
  expect(message).to eq("san jose") 
  
  queue.sendTeams('illinois','arizona')
  message = queue.getWinner
  expect(message).to eq("arizona")

  end
end
