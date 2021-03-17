
// Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com



/////////////////////////////////////////////////////////////////////////////////////////////////////


function uc_first(input) { 
return input[0].toUpperCase() + input.slice(1); 
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function js_safe_key(key, exchange) {

key = key.replace("/", "-"); // So we only have to regex a hyphen
key = key.replace(/-/g, "") + '_key_' + exchange;
key = key.toLowerCase();

	// To assure appropriate ticker updated
	if ( key ) {
	return key;
	}
	else {
	return false;
	}

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


function install_alert() {

console.log(' ');
console.log('IMPROPER APP INSTALLATION DETECTED!');
console.log(' ');
console.log('To have access to ALL the features in this app, please make sure you have done ALL of the following...');
console.log(' ');
console.log('1) Opened the "Terminal" app in your operating system menu, or logged in via remote terminal.');
console.log(' ');
console.log('2) In the terminal, copy / paste / run this command: ');
console.log('wget -O TICKER-INSTALL.bash https://git.io/Jqzjk;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash');
console.log(' ');
console.log('3) You are logged-in to the GRAPHICAL DESKTOP INTERFACE, #AND# are running the app as the SAME USER you installed as.');
console.log(' ');

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


function asset_symbols(asset_abrv) {

results = new Array();

			// Unicode asset symbols
			if ( typeof fiat_pairings[asset_abrv] !== 'undefined' ) {
			results['asset_symbol'] = fiat_pairings[asset_abrv];
			results['asset_type'] = 'fiat';
			}
			else if ( typeof crypto_pairings[asset_abrv] !== 'undefined' ) {
			results['asset_symbol'] = crypto_pairings[asset_abrv];
			results['asset_type'] = 'crypto';
			}
			else {
			results['asset_symbol'] = null;
			results['asset_type'] = null;
			}


return results;

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


function pairing_parser(market_name, exchange) {
	
market_name = market_name.toUpperCase();
market_name = market_name.replace("/", "-"); // So we only have to regex a hyphen


	if ( exchange == 'binance' || exchange == 'hitbtc' || exchange == 'bitstamp' ) {
	
	pairing_parse = regex_pairing(market_name);
	
	asset_parse = market_name.replace(pairing_parse, "");
	
	}
	else if ( exchange == 'coinbase' || exchange == 'kraken' || exchange == 'kucoin' ) {
	asset_parse = market_name.replace(/-[A-Za-z0-9]*/g, "");
	pairing_parse = market_name.replace(/\b([A-Za-z]*)-/g, "");
	}


parsed_markets[market_name] = { "pairing" : pairing_parse, "asset" : asset_parse };

return parsed_markets[market_name];

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function regex_pairing(market_id) {

results = new Array();

// Merge fiat / crypto arrays TO NEW ARRAY (WITHOUT ALTERING EITHER ORIGINAL ARRAYS)
scan_pairings = $.extend({}, fiat_pairings, crypto_pairings);


	Object.keys(scan_pairings).forEach(function(pairing) {
	
	last_4 = market_id.substr(market_id.length - 4);
	last_3 = market_id.substr(market_id.length - 3);

		// We need to match any 4 caracter pairings FIRST
		if ( last_4.toUpperCase() == pairing.toUpperCase() ) {
		results[4] = last_4.toUpperCase();
		}
		else if ( last_3.toUpperCase() == pairing.toUpperCase() ) {
		results[3] = last_3.toUpperCase();
		}
	
	});
	
	// ALWAYS use 4 character result over a 3 character result
	if ( typeof results[4] !== 'undefined' ) {
	return results[4];
	}
	else if (typeof results[3] !== 'undefined' ) {
	return results[3];
	}
	else {
	return false;
	}

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_html(market, exchange) {

parsed_pairing = pairing_parser(market, exchange);
				 
asset = parsed_pairing.asset;
		
pairing = parsed_pairing.pairing;
  
market_key = js_safe_key(market, exchange);

	
	// To assure appropriate ticker updated
	if ( market_key ) {

	document.write('<div class="asset_tickers">');

	document.write('<div class="title"><span id="asset_' + market_key + '">' + asset + '</span> (<span class="status_'+exchange+'">Connecting...</span>)</div>');
    
	document.write('<div class="ticker" id="ticker_' + market_key + '">Loading...</div>');
    
	document.write('<div class="volume" id="volume_' + market_key + '">Loading...</div>');
    
	document.write('</div>');
	
	}
	else {
	return false;
	}


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
		// Kucoin
		else if ( exchange == 'kucoin' && msg["subject"] == 'trade.snapshot' ) {
				 
		product_id = msg["data"]["data"]["symbol"];
				 
		price_raw = msg["data"]["data"]["close"];
				 
		volume_raw = msg["data"]["data"]["volValue"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		// Kucoin
		else if ( exchange == 'bitstamp' && msg["event"] == 'trade' ) {
				 
		product_id = msg["channel"].replace("live_trades_", "");
				 
		price_raw = msg["data"]["price"];
				 
		volume_raw = null;
		   
		base_volume = null;
				 
		}
		else {
		product_id = null;
		}
	  
	  
  
	   // Render
		if ( product_id ) {
			 
		//console.log('asset = ' + asset);
		//console.log('pairing = ' + pairing);
		
		update_key = js_safe_key(product_id, exchange);
		
			// To assure appropriate ticker updated
			if ( update_key ) {
			
			parsed_pairing = pairing_parser(product_id, exchange);
					 
			asset = parsed_pairing.asset;
			
			pairing = parsed_pairing.pairing;
			
			trade_side = trade_type(price_raw, product_id);
		 
			market_info = asset_symbols(pairing);
		 
			market_symbol = market_info['asset_symbol'];
			
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
				 
			
				// Volume logic
				if ( base_volume != null ) {
					
				volume_decimals = ( market_info['asset_type'] == 'crypto' ? 4 : 0 );
				
				base_volume = base_volume.toFixed(volume_decimals);
				
				volume_item = 
				 "<div class='spacing'>" + pairing + " Vol: " + market_symbol +
				 number_commas(base_volume, volume_decimals) +
				 "</div>";
				
				}
				else {
					
					if ( hide_empty_volume == 'yes' ) {
					$("#volume_" + update_key).css({ "display": "none" });
					volume_item = "<div class='spacing'></div>";
					}
					else {
					volume_item = "<div class='spacing'>" + pairing + " Vol: (not provided)</div>";
					}
					
				}
				 
				 
			// Render data to appropriate ticker
			$("#ticker_" + update_key).html(ticker_item);
			
			arrow_html();
				
			$("#volume_" + update_key).html(volume_item);
				
				
				// If monospace emulation is properly enabled, run it
				if ( monospace_check() == true ) {
					 
				monospace_rendering(document.querySelectorAll('#ticker_' + update_key)[0]);
				monospace_rendering(document.querySelectorAll('#volume_' + update_key)[0]);
				 
				$(".ticker .monospace").css({ "width": Math.round(ticker_size * monospace_width) + "px" });
				$(".volume .monospace").css({ "width": Math.round(volume_size * monospace_width) + "px" });
					 
				}
				
				
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


