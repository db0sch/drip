class BotMessages
  def respond(message)
    unless message = greetings(message)
      message = support(message)
    end
    message
  end

  private

  def greetings(message)
    words = ['hello', 'bonjour', 'salut', 'salu', 'helo', 'yo', 'bonsoir', 'wesh']
    return "Bonjour"if words.include?(message.downcase)
  end

  def support(message)
    # send the message and user info by email
    # send back a message to the user
    return "Merci. Votre message a bien été transféré à nos équipes. Nous espérons vous répondre rapidement."
  end
end
