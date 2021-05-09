
// Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com



/////////////////////////////////////////////////////////////////////////////////////////////////////


function uc_first(input) { 
return input[0].toUpperCase() + input.slice(1); 
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function load_js(file) {

script= document.createElement('script');
script.src= file;

head = document.getElementsByTagName('head')[0];
head.appendChild(script);

	script.onload = function(){
   console.log('Loaded JS file: ' + file);
   };

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


function console_alert() {

console.log(' ');
console.log('IMPROPER APP INSTALLATION DETECTED!');
console.log(' ');
console.log('To have access to ALL the features in this app, please make sure you have done ALL of the following...');
console.log(' ');
console.log('1) Open the "Terminal" app in your operating system interface menu, or login via remote terminal, AS THE USER YOU WANT RUNNING THE APP (user must have sudo privileges).');
console.log(' ');
console.log('2) In the terminal, copy / paste / run this command, THEN REBOOT when finished installing the app:');
console.log('wget --no-cache -O TICKER-INSTALL.bash https://git.io/Jqzjk;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash');
console.log(' ');
console.log('3) ON REBOOT / TICKER STARTUP, you are logged-in to the GRAPHICAL DESKTOP INTERFACE, #AND# are running the app as the SAME USER YOU INSTALLED AS.');
console.log(' ');

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function trade_type(price_raw, market_id) {
	
	if ( !trade_side_price[market_id] ) {
	trade_side_arrow[market_id] = 'buy'; // If just initiated, with no change yet
	}
	else if ( price_raw < trade_side_price[market_id] ) {
	trade_side_arrow[market_id] = 'sell';
	}
	else if ( price_raw > trade_side_price[market_id] ) {
	trade_side_arrow[market_id] = 'buy';
	}
		
trade_side_price[market_id] = price_raw;

return trade_side_arrow[market_id];

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


/////////////////////////////////////////////////////////////


function kucoin_config() {
	
	// If kucoin auth data is cached, allow kucoin configs
	if ( typeof kucoin_endpoint !== 'undefined' && typeof kucoin_token !== 'undefined' ) {
	api['kucoin'] = kucoin_endpoint + '?token=' + kucoin_token;
	console.log('Kucoin support enabled (valid installation detected).');
	return true;
	}
	// Remove kucoin market configs if no cache data is present, to avoid script errors,
	// and alert (to console ONLY) that app was improperly installed
	else {
	delete exchange_markets['kucoin']; 
	console_alert(); 
	console.log('Kucoin support disabled (invalid installation detected).');
	return false;
	}

}


/////////////////////////////////////////////////////////////


function init_interface() {

// Load cache.js dynamically, avoiding loading from the browser cache (lol, cachefest), via a timestamp url param
script= document.createElement('script');
script.src= 'cache/cache.js?cachebuster='+ new Date().getTime();

head = document.getElementsByTagName('head')[0];
head.appendChild(script);
	
	
	// If script loads OK
	script.onload = function(){
	console.log('JS cache file loaded successfully (valid installation detected).');
	render_interface();
   };

	
	// If script loading FAILS
	script.onerror = function(){
	console.log('JS cache file not found (invalid installation detected).');
	render_interface();
   };

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


function market_id_parser(market_id, exchange) {
	
market_id = market_id.toUpperCase(); // Uppercase

// So we only have to regex a hyphen, #CONVERT ALL DELIMITERS TO HYPHENS HERE#
market_id = market_id.replace("/", "-"); 


	// HYPHEN-delimited market IDs 
	// (ALL DELIMITERS ARE CONVERTED TO HYPHENS [IN THIS FUNCTION ONLY]...SEE market_id ABOVE)
	if ( exchange == 'coinbase' || exchange == 'kraken' || exchange == 'kucoin' ) {
	pairing = market_id.replace(/\b([A-Za-z]*)-/g, "");
	asset = market_id.replace(/-[A-Za-z0-9]*/g, "");
	}
	// NON-delimited market IDs
	else {
	pairing = regex_pairing_detection(market_id);
	asset = market_id.replace(pairing, "");
	}


parsed_markets[market_id] = { "pairing" : pairing, "asset" : asset };

return parsed_markets[market_id];

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function valid_config(exchange, mode) {

// Allows alphanumeric and symbols: / - _ |
alph_symb_regex = /^[a-z0-9\/\-_|]+$/i;

	// Skip, if no endpoint or markets are set for this exchange
	if ( 
	api[exchange] == '' 
	|| typeof api[exchange] == 'undefined'
	) {
	console.log(exchange + ' endpoint not defined, skipping ' + mode);
	return false;
	}
	else if ( typeof exchange_markets[exchange] == 'undefined' ) {
	console.log(exchange + ' markets not defined, skipping ' + mode);
	return false;
	}
	else if ( !exchange_markets[exchange].match(alph_symb_regex) ) {
	console.log(exchange + ' markets not properly setup (CHECK FOR BAD FORMATTING), skipping ' + mode);
	return false;
	}
	else {
	return true;
	}

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function regex_pairing_detection(market_id) {

results = new Array();

// Merge fiat / crypto arrays TO NEW ARRAY (WITHOUT ALTERING EITHER ORIGINAL ARRAYS)
scan_pairings = $.extend({}, fiat_pairings, crypto_pairings);

// last 4 / last 3 characters of the market id
last_4 = market_id.substr(market_id.length - 4);
last_3 = market_id.substr(market_id.length - 3);


	// Check for 4 character pairing configs existing FIRST
	if ( typeof scan_pairings[last_4.toUpperCase()] !== 'undefined' ) {
	return last_4.toUpperCase();
	}
	else if ( typeof scan_pairings[last_3.toUpperCase()] !== 'undefined' ) {
	return last_3.toUpperCase();
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


function ticker_html(market_id, exchange) {

    // Skip invalid exchange setups
    if ( valid_config(exchange, 'ticker_html') == false ) {
    return;
    }
	
parsed_market_id = market_id_parser(market_id, exchange);
				 
asset = parsed_market_id.asset;
		
pairing = parsed_market_id.pairing;
  
market_key = js_safe_key(market_id, exchange);

	
	// To assure appropriate ticker updated
	if ( typeof market_key !== 'undefined' ) {

	html = '<div id="wrapper_' + market_key + '" class="asset_tickers">'+
    
	'<div class="title" style="font-size: '+title_size+'px; font-weight: '+font_weight+';"><span id="asset_' + market_key + '">' + asset + '</span> (<span class="status_'+exchange+'">Connecting...</span>)</div>'+
	
	'<div class="ticker" style="font-size: '+ticker_size+'px; font-weight: '+font_weight+';" id="ticker_' + market_key + '">Loading...</div>'+
    
	'<div class="volume" style="font-size: '+volume_size+'px; font-weight: '+font_weight+';" id="volume_' + market_key + '"></div>'+
	
	'</div>';
	
	$(html).appendTo( "#ticker_window" );
	
	}
	else {
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


function ticker_init() {

	
ticker_divs = $('#ticker_window div.asset_tickers');


	// Slideshow init
	if ( typeof window.slideshow_init == 'undefined' ) {
	this_ticker = ticker_divs.first();
	window.slideshow_init = 1;
	}
	// Slideshow continue
	else {
	this_ticker = window.ticker_next;
	window.slideshow_init = 0;
	}

t_speed = Math.round(window.transition_speed * 1000);

   // If more than one market, run slideshow
	if ( markets_length > 1 ) {

	window.ticker_next = this_ticker.next().length ? this_ticker.next() : ticker_divs.first();

		// Slideshow init
		if ( window.slideshow_init == 1 ) {
		this_ticker.fadeIn(t_speed);
		}
		// Slideshow continue
		else {
			
		ticker_prev = this_ticker.prev().length ? this_ticker.prev() : ticker_divs.last();
			
   		ticker_prev.fadeOut(t_speed, function() {
   		this_ticker.fadeIn(t_speed);
			});
		
		}
	
   }
   // If just one market, leave showing
   else if ( markets_length == 1 ) {
   this_ticker.fadeIn(t_speed);
   }
	
   
}

/////////////////////////////////////////////////////////////////////////////////////////////////////


function render_interface() {

kucoin_config(); // Check / load kucoin data BEFORE MARKET CONFIG
	
market_config();


		// Connect to exchange APIs for market data
		// Render the HTML containers for each ticker
		Object.keys(markets).forEach(function(exchange) {
			
		api_connect(exchange);
		
			if ( markets[exchange] != '' ) {
			
  				markets[exchange].forEach(element => {
  				ticker_html(element, exchange);
				});
			
			}
		
		});

		
		// Start ticker
		// More than one asset, so run in slideshow mode (with delay of slideshow_speed seconds)
		if ( markets_length > 1 ) {
			
			// If auto mode for slideshow_speed (minimum of 5 seconds allowed)
			if ( slideshow_speed == 0 ) {
			slideshow_speed = Math.round(60 / window.markets_length);
			slideshow_speed = slideshow_speed < 5 ? 5 : slideshow_speed;
			}
			
		setInterval(ticker_init, slideshow_speed * 1000);
		
		}
		// If only one market
		else if ( markets_length == 1 ) {
		ticker_init();
		}
		

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function monospace_rendering($element) {
	
	if (  typeof $element !== 'undefined' ) {
	
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
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function market_config() {


// Exchange API endpoints

// WE DYNAMICALLY ADD THE KUCOIN ENDPOINT within render_interface()

api['binance'] = 'wss://stream.binance.com:9443/ws';

api['coinbase'] = 'wss://ws-feed.gdax.com';

api['kraken'] = 'wss://ws.kraken.com';

api['hitbtc'] = 'wss://api.hitbtc.com/api/2/ws';

api['bitstamp'] = 'wss://ws.bitstamp.net/';

api['bitfinex'] = 'wss://api.bitfinex.com/ws/1';



	// Put configged markets into a multi-dimensional array, calculate number of markets total
	Object.keys(exchange_markets).forEach(function(exchange) {
		
		if ( markets[exchange] != '' ) {
		markets[exchange] = exchange_markets[exchange].split("|");
		markets_length = markets_length + markets[exchange].length;
		}
			
	});



	// Websocket subscribe arrays
	Object.keys(markets).forEach(function(exchange) {
	
		// Coinbase
		if ( exchange == 'coinbase' ) {
			
		// API call config
		subscribe_msg[exchange] = {
					
				"type": "subscribe",
				"product_ids": [
				],
				"channels": [
						{
								"name": "ticker",
								"product_ids": [
								]
						}
				]
				};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange].product_ids[loop] = element;
			loop = loop + 1;
			});
		
		}
		// Binance
		else if ( exchange == 'binance' ) {
			
		// API call config
		subscribe_msg[exchange] = {
			"method": "SUBSCRIBE",
			"params": [
			],
			"id": 1
		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange].params[loop] = element + '@ticker'; 
			loop = loop + 1;
			});
		
		}
		// Kraken
		else if ( exchange == 'kraken' ) {
			
		// API call config
		subscribe_msg[exchange] = {
			"event": "subscribe",
			"pair": [
			],
			 "subscription": {
				"name": "ticker"
			 }
		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange].pair[loop] = element; 
			loop = loop + 1;
			});
		
		}
		// HitBTC
		else if ( exchange == 'hitbtc' ) {
			
		// API call config
		subscribe_msg[exchange] = {
			"method": "subscribeTicker",
			"params": {
			},
			"id": 1
		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange].params['symbol'] = element; 
			loop = loop + 1;
			});
		
		}
		// Kucoin
		// https://docs.kucoin.com/#symbol-ticker
		else if ( exchange == 'kucoin' ) {
			
		// API call config
		subscribe_msg[exchange] = {        
			"id": 1,
			"type": "subscribe",
			"topic": "/market/snapshot:",
			"privateChannel": false,
			"response": true       
		}
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange]['topic'] = subscribe_msg[exchange]['topic'] + element + ','; 
			loop = loop + 1;
			});
			
		subscribe_msg[exchange]['topic'] = subscribe_msg[exchange]['topic'].slice(0, -1) // remove last character
		
		}
		// Bitstamp
		// https://www.bitstamp.net/websocket/v2/
		else if ( exchange == 'bitstamp' ) {
			
		// API call config
		subscribe_msg[exchange] = { 
			"event": "bts:subscribe",
			"data": {
					"channel": "live_trades_"
			}  
		}
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange]['data']['channel'] = subscribe_msg[exchange]['data']['channel'] + element; 
			loop = loop + 1;
			});
		
		}
		// Bitfinex
		else if ( exchange == 'bitfinex' ) {
			
		// API call config
		subscribe_msg[exchange] = {
			"event": "subscribe",
			"channel": "ticker",
			"pair": ""
		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange]['pair'] = element; 
			loop = loop + 1;
			});
		
		}
		
	//console.log(subscribe_msg[exchange]);
	
	});



}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function api_connect(exchange) {


    // Skip invalid exchange setups
    if ( valid_config(exchange, 'api_connect') == false ) {
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
				 
		market_id = msg["product_id"];
				 
		price_raw = msg["price"];
				 
		volume_raw = msg["volume_24h"];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// Binance
		else if ( exchange == 'binance' && !msg["id"] && msg["e"] == '24hrTicker' ) {
				 
		market_id = msg["s"];
				 
		price_raw = msg["c"];
				 
		volume_raw = msg["q"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		// Kraken
		else if ( exchange == 'kraken' && !msg["event"] && msg[2] == 'ticker' ) {
				 
		market_id = msg[3];
				 
		price_raw = msg[1]["c"][0];
				 
		volume_raw = msg[1]["v"][1];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// HitBTC
		else if ( exchange == 'hitbtc' && !msg["result"] && msg["method"] == 'ticker' ) {
				 
		market_id = msg["params"]["symbol"];
				 
		price_raw = msg["params"]["last"];
				 
		volume_raw = msg["params"]["volumeQuote"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		// Kucoin
		else if ( exchange == 'kucoin' ) {
				 
			// If we have trade data available
			if ( msg["subject"] == 'trade.snapshot' ) {
					 
			market_id = msg["data"]["data"]["symbol"];
					 
			price_raw = msg["data"]["data"]["close"];
					 
			volume_raw = msg["data"]["data"]["volValue"];
			   
			base_volume = pair_volume('pairing', price_raw, volume_raw);
					 
			}
			// If we recieve an error reqponse
			else if ( msg["type"] == 'error' ) {
				
			console.log('Kucoin API Error: ' + msg["data"]);
			
				// Force refresh the webpage from server (NOT cache), 
				// if it's been at least 'min_error_refresh_time' since 'runtime_start'
				error_detected_timestamp = Number( new Date().getTime() ); 
				
				refresh_threshold = Number(runtime_start + min_error_refresh_time);
				
				console.log(' ');
				console.log('Refresh Alert: This app will attempt to fix the detected issue with an');
				console.log('app restart (no more than every ' + (min_error_refresh_time / 60000) + ' minutes, until the error clears up).');
				console.log(' ');
				
				// Reload, if we are within the minimum reload time window
				if ( error_detected_timestamp >= refresh_threshold ) {
				location.reload(true);
				}
			
			}
				 
		}
		// Bitstamp
		else if ( exchange == 'bitstamp' && msg["event"] == 'trade' ) {
				 
		market_id = msg["channel"].replace("live_trades_", "");
				 
		price_raw = msg["data"]["price"];
		
		// RE-SET volume_raw / base_volume AS UNDEFINED, as bitstamp provides no volume data
		
		var volume_raw;
		
		var base_volume;
				 
		}
		// Bitfinex
		else if ( exchange == 'bitfinex' && msg.length == 11 ) {
				 
		market_id = subscribe_msg[exchange]['pair'];
				 
		price_raw = msg[7];
				 
		volume_raw = msg[8];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
	  
	    
	    // Nullify rendering under these circumstances (msg is not our data set)
	    if ( 
	    exchange == 'bitfinex' && msg[1] == 'hb' // Bitfinex
	    ) {
	    var market_id;
	    }
	    
  
	   // Render (IF market_id is defined)
		if ( typeof market_id !== 'undefined' ) {
			 
		//console.log('asset = ' + asset);
		//console.log('pairing = ' + pairing);
		
		update_key = js_safe_key(market_id, exchange);
		
			// To assure appropriate ticker updated
			if ( typeof update_key !== 'undefined' ) {
			
			parsed_market_id = market_id_parser(market_id, exchange);
					 
			asset = parsed_market_id.asset;
			
			pairing = parsed_market_id.pairing;
			
			trade_side = trade_type(price_raw, market_id);
		 
			market_info = asset_symbols(pairing);
		 
			market_symbol = market_info['asset_symbol'];
			
			// Price decimals
			price_decimals = ( price_raw >= 1 ? 2 : max_ticker_decimals );
			price = parseFloat(price_raw).toFixed(price_decimals);
				
			// HTML for rendering
			ticker_item =
				 "<div class='spacing'><div class='arrow_wrapper' style=''><span class='arrow " +
				 trade_side +
				 "'></span></div><span class='tick_text'>" + market_symbol +
				 number_commas(price, price_decimals) +
				 "</span></div>";
				 
			
				// Volume logic
				if ( typeof base_volume !== 'undefined' ) {
					
				volume_decimals = ( market_info['asset_type'] == 'crypto' ? 4 : 0 );
				
				base_volume = Number(base_volume).toFixed(volume_decimals);
				
				volume_item = 
				 "<div class='spacing'>Vol: " + market_symbol +
				 number_commas(base_volume, volume_decimals) +
				 "</div>";
				
				}
				else {
					
					if ( hide_empty_volume == 'yes' ) {
					$("#volume_" + update_key).css({ "display": "none" });
					volume_item = "<div class='spacing'></div>";
					}
					else {
					volume_item = "<div class='spacing'>Vol: (not provided)</div>";
					}
					
				}
				 
				 
			// Render data to appropriate ticker
			
			$("#ticker_" + update_key).html(ticker_item);
			
			arrow_html(); // #MUST BE# AFTER TICKER RENDERING ABOVE
				
			$("#volume_" + update_key).html(volume_item);
				
				
				// If monospace emulation is properly enabled, run it
				if ( monospace_check() == true ) {
					
				monospace_rendering(document.querySelectorAll('#ticker_' + update_key)[0]);
				
					if ( typeof base_volume !== 'undefined' ) {
					monospace_rendering(document.querySelectorAll('#volume_' + update_key)[0]);
					}
					 
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


