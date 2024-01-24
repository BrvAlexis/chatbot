require 'dotenv'# Appelle la gem Dotenv
require 'http'
require 'json'

Dotenv.load # Ceci appelle le fichier .env (situé dans le même dossier que celui d'où tu exécute app.rb)
# et grâce à la gem Dotenv, on importe toutes les données enregistrées dans un hash ENV

# création de la clé d'api et indication de l'url utilisée.

api_key = ENV["OPENAI_API_KEY"]
url = "https://api.openai.com/v1/completions"


headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}

response = HTTP.get(url, headers: headers)




# un peu de json pour envoyer des informations directement à l'API
data = {
"model" => "gpt-3.5-turbo-instruct",
"prompt" => "Hello, voici 1 recette de cuisine aléatoire",
"max_tokens" => 200,
"temperature" => 0.5
}

# une partie un peu plus complexe :
# - cela permet d'envoyer les informations en json à ton url
# - puis de récupéré la réponse puis de séléctionner spécifiquement le texte rendu
response = HTTP.post(url, headers: headers, body: data.to_json)
response_body = JSON.parse(response.body.to_s)

response_string = response_body['choices'][0]['text'].strip



# ligne qui permet d'envoyer l'information sur ton terminal
puts "Hello, voici 1 recette de cuisine aléatoire , rapie à réaliser :"
puts response_string

    