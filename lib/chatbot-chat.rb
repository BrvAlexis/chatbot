require 'dotenv'# Appelle la gem Dotenv
require 'http'
require 'json'

Dotenv.load # Ceci appelle le fichier .env (situé dans le même dossier que celui d'où tu exécute app.rb)
# et grâce à la gem Dotenv, on importe toutes les données enregistrées dans un hash ENV

# création de la clé d'api et indication de l'url utilisée.


api_key = ENV["OPENAI_API_KEY"]

def converse_with_ai(api_key, conversation_history)
    url = "https://api.openai.com/v1/completions"
    endpoint = "gpt-3.5-turbo-instruct"
    loop do
        # Get user input
        puts "You: "
        user_input = gets.chomp

        # Break the loop if the user says "stop"
        break if user_input.downcase == 'stop'

        # Append user input to the conversation history
        conversation_history += "\nUser: #{user_input}"

        # Build the complete prompt with conversation history
        prompt = "#{conversation_history}\nBot:"

    headers = {
    "Content-Type" => "application/json",
     "Authorization" => "Bearer #{api_key}"
    }

    response = HTTP.get(url, headers: headers)

    # un peu de json pour envoyer des informations directement à l'API
    data = {
    "model" => endpoint,
    "prompt" => prompt,
    "max_tokens" => 200,
    "temperature" => 0.5
    }

    # une partie un peu plus complexe :
    # - cela permet d'envoyer les informations en json à ton url
    # - puis de récupéré la réponse puis de séléctionner spécifiquement le texte rendu
    response = HTTP.post(url, headers: headers, body: data.to_json)
    response_body = JSON.parse(response.body.to_s)

    

    # Extract and print the generated text
    bot_response = response_body['choices'][0]['text'].strip
    puts "Bot: #{bot_response}"

    # Append bot's response to the conversation history
    conversation_history += "\nBot: #{bot_response}"
    
    end
end


initial_conversation_history = "User: Hello, bot!\nBot: Hi there! Let's chat."

converse_with_ai(api_key, initial_conversation_history)









    