require 'sinatra'
require 'json'
require 'mail'
require 'tmail'
require 'gmail'
require 'nokogiri'
require 'open-uri'
require'date'

def remove_gmailExcess(doc)
  doc.css("div.gmail_quote, blockquote.gmail_quote").remove
end

def remove_hotmailExcess(doc)
end

def remove_yahooExcess(doc)
end



def remove_time(node)
  months = Date::ABBR_MONTHNAMES
  months.each { |m|
    if(node.content.include? "On #{m}")
      node.remove
    end 
  }
end

def remove_sent_from_iphone(node)
  if(node.content.include? "Sent from my iPhone")
    node.content = node.content.sub("Sent from my iPhone", "")
  end
end

def remove_blocquote_cite(doc)
  doc.css("blockquote").each {|n|
    blockquoteAttr = n.attributes["type"].to_s
    if blockquoteAttr == "cite"
      n.remove
    end
  }
end

def remove_signature(node)
  if(node.content.include?"--")
    node.remove
  end
end

def remove_google_groups(doc)
  googleGroupMSG = Array.new
  googleGroupMSG.push("To unsubscribe from this group",
  "You received this message because you are subscribed",
  "For more options, visit this group",
  "You received this message because you are subscribed to the Google Groups",
  "To post to this group, send email to")
  
  googleGroupMSG.cycle(1) {|x|
    doc.css("br").each {|n|
      if(n.previous().content.include? x)
            n.previous.remove
            n.remove
      end
    } 
  }
end

def remove_yahoo_groups(doc)
end

def remove_hotmail_groups(doc)
end

def collect_between(first, last)
  if first.respond_to?('next')
    first == last ? [first] : [first, *collect_between(first.next, last)]
  end
end

def parse_plain_text_email(doc)
  @end_element = doc.at('body')
  doc.css("br").each {|n|

    if(n)
      if n.next_sibling().respond_to?('content')
        if(n.next_sibling().content.include? "Muzzammil Zaveri")
          
          tempCollection =  collect_between(n, @end_element.last_element_child)
          tempCollection.each {|t| t.remove}
          
          # puts n.next_sibling().next.next.next.next.next.next.next.next
          # n.css("").each {|temp|
          #   puts "monkey"
          #   puts temp
          # }
          # until n.css"body"
          #   puts "ballin"
          # end
        end
        # puts "IT IS INCLUDED"
        # n.next_sibling().remove
        # n.children.remove
        # n.remove
      else
        # puts "NO GO"
      end
      # puts n.next_sibling().content

      # n.children.remove
      # n.remove
    end

  }
  
  # doc.css("br").each {|n|
  # 
  #   if(n)
  #     if n.next_sibling().respond_to?('content')
  #       # puts "IT IS INCLUDED"
  #       n.next_sibling().remove
  #       n.children.remove
  #       n.remove
  #     else
  #       # puts "NO GO"
  #     end
  #   end
  # 
  # }
  # 
  # doc.css("br").each {|n|
  #   # puts "inisd this cool method"
  #   # puts n.next()
  #   if n.next().content != nil
  #     if(n.next().content.include? "Muzzammil Zaveri <m.h.zaveri@gmail.com>")
  #       puts "IT IS INCLUDED"
  #       n.children.remove
  #       n.remove
  #     end
  #   end
  # }
end



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
  
  doc.css("div.gmail_quote, blockquote.gmail_quote").remove
  
  # remove from my iPhone, sent on,  blockquote cite (reference is email from ED)

  doc.css("div").each {|n|
    remove_sent_from_iphone(n)
    remove_time(n)
    remove_signature(n)
  }
  
  remove_blocquote_cite(doc)
  parse_plain_text_email(doc)
  # remove_google_groups(doc)
      
  content_type :json
  return {:parsed_email => doc}.to_json
end