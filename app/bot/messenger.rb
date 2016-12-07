include Facebook::Messenger

Bot.on :message do |message|
  # log message
  puts "Received '#{message.inspect}' from #{message.sender}"

  message.reply(text: 'Hello, human!')

  # call a service that takes the message
  # and create a message instance
  # put it in a background job
  # and send it to me via email
end

Bot.on :postback do |postback|
  # call a service that takes the postback
  # and send back a result / message
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
  # call a service
  # which will add the delivery info to an instance
end

Bot.on :read do |read|
  p read
  puts "Last message read_at #{Time.now}"
  # call a service
  # which will add the reading info to an interest instance
end
