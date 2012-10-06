require 'sinatra'
require 'json'
require 'mail'
require 'tmail'
require 'gmail'
require 'nokogiri'
require 'open-uri'

get '/' do
  return "GANGNAM SYLE"
end

get '/sushi.json' do
  content_type :json
  return {:sushi => ["Maguro", "Hamachi", "Uni", "Saba", "Ebi", "Sake", "Tai"]}.to_json
end

post '/parse.json' do
  htmlBody = params[:html_body]
  doc = Nokogiri::HTML.parse(htmlBody, 'UTF-8')
  doc.css("div.gmail_quote").remove
  content_type :json
  return {:parsed_email => doc}.to_json
end