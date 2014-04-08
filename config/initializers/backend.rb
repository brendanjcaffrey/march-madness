if Rails.env.production?
  puts 'App was started in production mode, waiting for connection from backend...'
  $backend = ServerConnection.new
  $backend.connect
  puts 'Connected!'
end

