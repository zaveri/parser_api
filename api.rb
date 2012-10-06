require 'sinatra'
require 'json'
require 'mail'
require 'tmail'
require 'gmail'
require 'nokogiri'
require 'open-uri'

get '/sushi.json' do
  content_type :json
  return {:sushi => ["Maguro", "Hamachi", "Uni", "Saba", "Ebi", "Sake", "Tai"]}.to_json
end

post '/parse' do
  htmlBody = params[:html_body]
  doc = Nokogiri::HTML.parse(htmlBody, 'UTF-8')
  doc.css("div.gmail_quote").remove
  return doc
end