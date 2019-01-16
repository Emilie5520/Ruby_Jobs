require "json"
require "time"
require "pp"

def parse_date(date) 
  Date.parse(date).strftime('%F')
end  

def price_total_pages(communication)
  (communication['pages_number'] - 1) * price_page
end

def price_page
	0.07
end

def price_communication
	0.10
end

def price_color
	0.18
end

def price_express_delivery(practitioner)
  0.60
end

def has_color?(communication)
	communication['color'] == true
end

def has_express_delivery?(practitioner)
	practitioner['express_delivery'] == true
end

def totaux(data_hash, parsed_date)
  pages = 0
  com = 0
  color = 0
  express = 0
  result = 0

    data_hash['communications'].select { |communication| parse_date(communication['sent_at']) == parsed_date }.each do |communication|
    	pages += price_total_pages(communication)
    	com += price_communication
    	color += price_color if has_color?(communication)

	  	data_hash['practitioners'].select { |practitioner| practitioner['id'] == communication['practitioner_id']}.each do |practionner|
	  		express += price_express_delivery(practionner) if has_express_delivery?(practionner)
	    end	    
	  end
	  resultat = (pages + com + color + express).round(2)
end

data = File.read('data.json')
data_hash = JSON.parse(data)

final = Hash.new
final['totals'] = Array.new

data_hash['communications'].each do |communication|
  parsed_date = parse_date(communication['sent_at'])
    totals = {
	'sent_on' => parsed_date,
	'total' => totaux(data_hash, parsed_date)
    }
  final['totals'] << totals 
end

final['totals'] = final['totals'].uniq
pp final
