require 'spec_helper'
require 'rake'
require "#{Rails.root}/app/helpers/server_connection"

describe 'espnAPI:scrape' do
  it 'should create the conferences and teams' do
  
  queue = ServerConnection.new

  puts 'connecting'
  queue.connect

  queue.send("hello")

  end
end
