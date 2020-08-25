
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com



/////////////////////////////////////////////////////////////////////////////////////////////////////


function uc_first(input) { 
return input[0].toUpperCase() + input.slice(1); 
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function js_safe_key(key, exchange) {

js_key = key;
js_key = js_key.replace("/", "-"); // So we only have to regex a hyphen
js_key = js_key.replace(/-/g, "") + '_key_' + exchange;
js_key = js_key.toLowerCase();

return js_key;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function pair_volume(volume_type, trade_value, volume) {
	
	if ( typeof volume == 'string' ) {
	volume = parseFloat(volume);
	}

	if ( volume_type == 'asset' ) {
	base_volume = trade_value * volume; // Roughly emulate pairing volume for UX
	}
	else if ( volume_type == 'pairing' ) {
	base_volume = volume;
	}
	
return base_volume;

}



/////////////////////////////////////////////////////////////////////////////////////////////////////


function trade_type(price_raw, product_id) {
	
	if ( !trade_side_price[product_id] ) {
	trade_side_arrow[product_id] = 'buy'; // If just initiated, with no change yet
	}
	else if ( price_raw < trade_side_price[product_id] ) {
	trade_side_arrow[product_id] = 'sell';
	}
	else if ( price_raw > trade_side_price[product_id] ) {
	trade_side_arrow[product_id] = 'buy';
	}
		
trade_side_price[product_id] = price_raw;

return trade_side_arrow[product_id];

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function arrow_html() {

arrow_height = Math.round(ticker_size * arrow_size);
arrow_width = Math.round(arrow_height * 0.84);
arrow_border_width = Math.round(arrow_width / 2);
	
// Arrow height
$("div.arrow_wrapper").css({ "height": arrow_height + "px" });
$("span.buy").css({ "border-bottom": arrow_height + "px solid rgb(105, 199, 115)" });
$("span.sell").css({ "border-top": arrow_height + "px solid rgb(199, 105, 105)" });

// Arrow width
$("div.arrow_wrapper").css({ "width": arrow_width + "px" });
$("span.arrow").css({ "border-left": arrow_border_width + "px solid transparent" });
$("span.arrow").css({ "border-right": arrow_border_width + "px solid transparent" });

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_init() {
	
var divs= $('#ticker_window div.asset_tickers'),

now = divs.filter(':visible'),

next = now.next().length ? now.next() : divs.first(),

speed = 1000;

    
	if ( markets_length > 1 ) {
    now.fadeOut(speed);
    next.delay(speed + 100).fadeIn(speed);
   }
   else {
   next.fadeIn(speed);
   }
   
   
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function number_commas(num, decimals) {
	
//console.log(typeof num);
	
	if ( num >= 1 ) {
		
		if ( typeof num == 'string' ) {
		
			num = parseFloat(num).toLocaleString(undefined, {
   		minimumFractionDigits: decimals,
   		maximumFractionDigits: decimals
			});
		
		}
		else {
		
			num = num.toLocaleString(undefined, {
   		minimumFractionDigits: decimals,
   		maximumFractionDigits: decimals
			});
		
		}
	
	}


return num;
   
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_html(market, exchange) {

parsed_pairing = pairing_parser(market, exchange);
				 
asset = parsed_pairing.asset;
		
pairing = parsed_pairing.pairing;
  
js_key = js_safe_key(market, exchange);


document.write('<div class="asset_tickers">');

document.write('<div class="title"><span id="asset_' + js_key + '">' + asset + '</span> (<span class="status_'+exchange+'">Connecting...</span>)</div>');
    
document.write('<div class="ticker" id="ticker_' + js_key + '"></div>');
    
document.write('<div class="volume" id="volume_' + js_key + '"></div>');
    
document.write('</div>');


}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function pairing_parser(market_name, exchange) {
	
market_name = market_name.toUpperCase();
market_name = market_name.replace("/", "-"); // So we only have to regex a hyphen


	if ( exchange == 'binance' || exchange == 'hitbtc' ) {
	
	pairing_parse = market_name;
	pairing_parse = pairing_parse.replace(/\b([A-Z]{3})TUSD/g, "TUSD");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{3})USD/g, "USD");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{3})BTC/g, "BTC");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{3})BTC/g, "XBT");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{3})ETH/g, "ETH");
	
	pairing_parse = pairing_parse.replace(/\b([A-Z]{4})TUSD/g, "TUSD");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{4})USD/g, "USD");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{4})BTC/g, "BTC");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{4})BTC/g, "XBT");
	pairing_parse = pairing_parse.replace(/\b([A-Z]{4})ETH/g, "ETH");
	
	asset_parse = market_name.replace(pairing_parse, "");
	
	}
	else if ( exchange == 'coinbase' || exchange == 'kraken' ) {
	asset_parse = market_name.replace(/-[A-Za-z0-9]*/g, "");
	pairing_parse = market_name.replace(/\b([A-Za-z]*)-/g, "");
	}


parsed_markets[market_name] = { "pairing" : pairing_parse, "asset" : asset_parse };

//console.log(parsed_markets[market_name]);

return parsed_markets[market_name];

}
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////


function render_names(name) {
	
render = name.charAt(0).toUpperCase() + name.slice(1);

render = render.replace(/btc/gi, "BTC");
render = render.replace(/coin/gi, "Coin");
render = render.replace(/bitcoin/gi, "Bitcoin");
render = render.replace(/exchange/gi, "Exchange");
render = render.replace(/market/gi, "Market");
render = render.replace(/forex/gi, "Forex");
render = render.replace(/finex/gi, "Finex");
render = render.replace(/stamp/gi, "Stamp");
render = render.replace(/flyer/gi, "Flyer");
render = render.replace(/panda/gi, "Panda");
render = render.replace(/pay/gi, "Pay");

return render;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function monospace_check() {
	
check = monospace_width;


	// Not a number check
	if ( isNaN(check) ) {
   return false;
	}


// Second number check, with check for decimals with value of 1.00 or less
var result = (check - Math.floor(check)) !== 0; 
   
   
  if (result) { // Is a decimal number
  
  	if ( monospace_width > 1 ) { // Is greater than 1.00
  	return false;
  	}
  	else { // Is NOT greater than 1.00
  	return true;
  	}
  	
  }
  else { // Is not a decimal number
  return false;
  }
     
     
 }


/////////////////////////////////////////////////////////////////////////////////////////////////////


function load_google_font() {
	
config_font = google_font;

	// Skip custom font rendering if no config value
	if ( config_font == null ) {
	return false;
	}

formatted_link = config_font.split(' ').join('+');


// Get HTML head element 
head = document.getElementsByTagName('HEAD')[0];  
  
// Create new link Element 
link = document.createElement('link'); 
  
// set the attributes for link element  
link.rel = 'stylesheet';  
      
link.type = 'text/css'; 
      
link.href = 'https://fonts.googleapis.com/css?family=' + formatted_link + '&display=swap';  

// Append link element to HTML head 
head.appendChild(link); 

// DEBUGGING
//console.log("google_font = " + config_font);
//console.log("Formatted for CSS link: " + formatted_link);
console.log("Google font CSS href link set as: " + link.href);

return "'" + config_font + "', serif, monospace";

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function monospace_rendering($element) {
	
    for (var i = 0; i < $element.childNodes.length; i++) {
    
    var $child = $element.childNodes[i];

        if ($child.nodeType === Node.TEXT_NODE) {
        	
        var $wrapper = document.createDocumentFragment();

            for (var i = 0; i < $child.nodeValue.length; i++) {
            	
            	if ( isNaN($child.nodeValue.charAt(i)) || $child.nodeValue.charAt(i) == ' ' ) { // Space not detected well here, lol...so we work-around
                var $char = document.createElement('span');
                $char.textContent = $child.nodeValue.charAt(i);
                }
                else {
                var $char = document.createElement('span');
                $char.className = 'monospace';
                $char.textContent = $child.nodeValue.charAt(i);
                }

            $wrapper.appendChild($char);
                
            }

        $element.replaceChild($wrapper, $child);
        
        } 
        else if ($child.nodeType === Node.ELEMENT_NODE) {
        monospace_rendering($child);
        }
        
    }
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function asset_symbols(asset_abrv) {

results = new Array();

			// Unicode asset symbols
			if ( asset_abrv == 'AUD' ) {
			results['asset_symbol'] = "A$";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'BRL' ) {
			results['asset_symbol'] = "R$";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'BTC' ) {
			results['asset_symbol'] = "Ƀ ";
			results['asset_type'] = 'crypto';
			}
			else if ( asset_abrv == 'XBT' ) {
			results['asset_symbol'] = "Ƀ ";
			results['asset_type'] = 'crypto';
			}
			else if ( asset_abrv == 'CAD' ) {
			results['asset_symbol'] = "C$";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'CHF' ) {
			results['asset_symbol'] = "CHf";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'ETH' ) {
			results['asset_symbol'] = "Ξ ";
			results['asset_type'] = 'crypto';
			}
			else if ( asset_abrv == 'EUR' ) {
			results['asset_symbol'] = "€";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'GBP' ) {
			results['asset_symbol'] = "£";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'HKD' ) {
			results['asset_symbol'] = "HK$";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'JPY' ) {
			results['asset_symbol'] = "J¥";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'RUB' ) {
			results['asset_symbol'] = "₽";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'SGD' ) {
			results['asset_symbol'] = "S$";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'TUSD' || asset_abrv == 'USDC' ) {
			results['asset_symbol'] = "Ⓢ ";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'USD' ) {
			results['asset_symbol'] = "$";
			results['asset_type'] = 'fiat';
			}
			else if ( asset_abrv == 'USDT' ) {
			results['asset_symbol'] = "₮ ";
			results['asset_type'] = 'fiat';
			}


return results;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function api_connect(exchange) {

	//console.log('api_connect = ' + exchange);
	
	// Exit function if no endpoint set
	if ( api[exchange] == '' ) {
	return;
	}
	
	
	// Create new socket
	sockets[exchange] = new WebSocket(api[exchange]);
	
   
	// Open socket ///////////////////////////////////////////////////
	sockets[exchange].onopen = function() {
   
	sockets[exchange].send(JSON.stringify(subscribe_msg[exchange]));
	   
	 	markets[exchange].forEach(element => {
	   $(".status_" + exchange).text( render_names(exchange) ).css("color", "#2bbf7b");
	   });
	   
	};
   
   
	// Socket response ///////////////////////////////////////////////////
	sockets[exchange].onmessage = function(e) {
	   
	msg = JSON.parse(e.data);
	//console.log(msg);
		
		// Parse exchange data
		
		// Coinbase
		if ( exchange == 'coinbase' && msg["type"] == 'ticker' ) {
				 
		product_id = msg["product_id"];
				 
		price_raw = msg["price"];
				 
		volume_raw = msg["volume_24h"];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// Binance
		else if ( exchange == 'binance' && !msg["id"] && msg["e"] == '24hrTicker' ) {
				 
		product_id = msg["s"];
				 
		price_raw = msg["c"];
				 
		volume_raw = msg["q"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		// Kraken
		else if ( exchange == 'kraken' && !msg["event"] && msg[2] == 'ticker' ) {
				 
		product_id = msg[3];
				 
		price_raw = msg[1]["c"][0];
				 
		volume_raw = msg[1]["v"][1];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// HitBTC
		else if ( exchange == 'hitbtc' && !msg["result"] && msg["method"] == 'ticker' ) {
				 
		product_id = msg["params"]["symbol"];
				 
		price_raw = msg["params"]["last"];
				 
		volume_raw = msg["params"]["volumeQuote"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		else {
		product_id = null;
		}
	  
	  
  
	   // Render
		if ( product_id ) {
			 
		//console.log('asset = ' + asset);
		//console.log('pairing = ' + pairing);
		
		js_key = js_safe_key(product_id, exchange);
		
		parsed_pairing = pairing_parser(product_id, exchange);
				 
		asset = parsed_pairing.asset;
		
		pairing = parsed_pairing.pairing;
		
		trade_side = trade_type(price_raw, product_id);
	 
		market_info = asset_symbols(pairing);
	 
		market_symbol = market_info['asset_symbol'];
		
		// Volume decimals
		volume_decimals = ( market_info['asset_type'] == 'crypto' ? 4 : 0 );
		base_volume = base_volume.toFixed(volume_decimals);
		
		// Price decimals
		price_decimals = ( price_raw >= 1 ? 2 : max_price_decimals );
		price = parseFloat(price_raw).toFixed(price_decimals);
		   
		// HTML for rendering
		ticker_item =
			 "<div class='spacing'><div class='arrow_wrapper' style=''><span class='arrow " +
			 trade_side +
			 "'></span></div><span class='tick_text'>" + market_symbol +
			 number_commas(price, price_decimals) +
			 "</span></div>";
			 
		volume_item = 
			 "<div class='spacing'>" + pairing + " Vol: " + market_symbol +
			 number_commas(base_volume, volume_decimals) +
			 "</div>";
			 
			 
		// Render data to appropriate ticker
		$("#ticker_" + js_key).html(ticker_item);
		
		arrow_html();
		
		$("#volume_" + js_key).html(volume_item);
		   
		   
			// If monospace emulation is properly enabled, run it
			if ( monospace_check() == true ) {
				 
			monospace_rendering(document.querySelectorAll('#ticker_' + js_key)[0]);
			monospace_rendering(document.querySelectorAll('#volume_' + js_key)[0]);
			 
			$(".ticker .monospace").css({ "width": Math.round(ticker_size * monospace_width) + "px" });
			$(".volume .monospace").css({ "width": Math.round(volume_size * monospace_width) + "px" });
				 
			}
			
				 
		}
	   
	   
	};
   
   
	
	// When socket closes, reconnect ///////////////////////////////////////////////////
	sockets[exchange].onclose = function(e) {
		
	//console.log('Connecting', e.reason);
	   
		setTimeout(function() {
	   $(".status_" + exchange).text("Connecting").css("color", "red");
		api_connect(exchange);
	   }, 60000); // Reconnect after no data received for 1 minute
	   
	};
   
   
   
	// Socket error ///////////////////////////////////////////////////
	sockets[exchange].onerror = function(err) {
	$(".status_" + exchange).text("Error").css("color", "red");
	console.log('Socket encountered error: ', err.message, 'Closing socket');
	sockets[exchange].close();
	};
	
  
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


