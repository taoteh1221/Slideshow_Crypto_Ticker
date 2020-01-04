
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com



/////////////////////////////////////////////////////////////////////////////////////////////////////


function uc_first(input) { 

var string = input; 

return string[0].toUpperCase() + string.slice(1); 

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function number_commas(num) {
	
	if ( num >= 1 ) {
	return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
   else {
   return num;
   }
   
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_html(market) {
	
var asset = market.replace(/-[A-Za-z0-9]*/g, "");

var js_key = market.replace(/-/g, "");

document.write('<div class="asset_tickers">');

document.write('<div class="title"><span id="asset_' + js_key + '">' + asset + '</span> (<span class="status">Connecting...</span>)</div>');
    
document.write('<div class="ticker" id="ticker_' + js_key + '"></div>');
    
document.write('<div class="volume" id="volume_' + js_key + '"></div>');
    
document.write('</div>');

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_init() {
	
var divs= $('#ticker_window div.asset_tickers'),

now = divs.filter(':visible'),

next = now.next().length ? now.next() : divs.first(),

speed = 1000;

    
	if ( window.markets.length > 1 ) {
    now.fadeOut(speed);
    next.delay(speed + 100).fadeIn(speed);
   }
   else {
   next.fadeIn(speed);
   }
   
   
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function monospace_check() {
	
var check = window.monospace_width;

	// Not a number check
	if ( isNaN(check) ) {
   return false;
	}


// Second number check, with check for decimals with value of 1.00 or less
var result = (check - Math.floor(check)) !== 0; 
   
  if (result) { // Is a decimal number
  
  	if ( window.monospace_width > 1 ) { // Is greater than 1.00
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
	
var config_font = window.google_font;

	// Skip custom font rendering if no config value
	if ( config_font == null ) {
	return false;
	}

var formatted_link = config_font.split(' ').join('+');


// Get HTML head element 
var head = document.getElementsByTagName('HEAD')[0];  
  
// Create new link Element 
var link = document.createElement('link'); 
  
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
			else if ( asset_abrv == 'LTC' ) {
			results['asset_symbol'] = "Ł ";
			results['asset_type'] = 'crypto';
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
			else if ( asset_abrv == 'XMR' ) {
			results['asset_symbol'] = "ɱ ";
			results['asset_type'] = 'crypto';
			}



return results;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function api_connect() {


	if ( window.crypto_exchange == 'coinbase' ) {
	var socket = new WebSocket('wss://ws-feed.gdax.com');
	}
  
 
	
	// Open socket ///////////////////////////////////////////////////
	socket.onopen = function() {
   
	socket.send(JSON.stringify(window.subscribe_msg));
	
	   
	 	window.markets.forEach(element => {
	 		
	   var asset = element.replace(/-[A-Za-z0-9]*/g, "");
	   
	   $(".status").text( uc_first(window.crypto_exchange) ).css("color", "#2bbf7b");
	   
	   });
   
	   
	};
   
   
   
	// Socket response ///////////////////////////////////////////////////
	socket.onmessage = function(e) {
	   
	var msg = JSON.parse(e.data);
	   
	//console.log(msg);
		   
		   
		if ( window.crypto_exchange == 'coinbase' ) {
					 
		var api_field = msg["type"];
				 
		var product_id = msg["product_id"];
				 
		var price_raw = msg["price"];
				 
		var volume_raw = msg["volume_24h"];
			 
		var trade_side = msg["side"];
				 
		var asset = product_id.replace(/-[A-Za-z0-9]*/g, "");
				 
		var pairing = product_id.replace(/\b([A-Za-z]*)-/g, "");
				 
		var js_key = product_id.replace(/-/g, "");
				 
		}
	  
	  
		if ( api_field == "ticker" ) {
			 
		//console.log(asset);
		//console.log(pairing);
	 
		var market_info = asset_symbols(pairing);
	 
		var market_symbol = market_info['asset_symbol'];
		   
		var volume_decimals = ( market_info['asset_type'] == 'crypto' ? 3 : 0 );
		   
		var base_volume = price_raw * parseFloat(volume_raw);
		   
		base_volume = base_volume.toFixed(volume_decimals);
			 
		var price_decimals = ( price_raw >= 1 ? 2 : window.max_price_decimals );
			 
		var price = parseFloat(price_raw).toFixed(price_decimals);
		   
		var ticker_item =
			 "<div class='spacing'><div class='arrow_wrapper'><span class='arrow " +
			 trade_side +
			 "'></span></div><span class='tick_text'>" + market_symbol +
			 number_commas(price) +
			 "</span></div>";
			 
		var volume_item = 
			 "<div class='spacing'>" + pairing + " Vol: " + market_symbol +
			 number_commas(base_volume) +
			 "</div>";
			 
			 
		// Render data to appropriate ticker
		$("#ticker_" + js_key).html(ticker_item);
		$("#volume_" + js_key).html(volume_item);
		   
		   
			// If monospace emulation is properly enabled, run it
			if ( monospace_check() == true ) {
				 
			monospace_rendering(document.querySelectorAll('#ticker_' + js_key)[0]);
			monospace_rendering(document.querySelectorAll('#volume_' + js_key)[0]);
			 
			$(".ticker .monospace").css({ "width": Math.round(window.ticker_size * window.monospace_width) + "px" });
			$(".volume .monospace").css({ "width": Math.round(window.volume_size * window.monospace_width) + "px" });
				 
			}
			
				 
		}
	   
	   
	};
   
   
	
	// When socket closes ///////////////////////////////////////////////////
	socket.onclose = function(e) {
		
	//console.log('Connecting', e.reason);
	   
	   
		setTimeout(function() {
			
	   $(".status").text("Connecting").css("color", "red");
		
		api_connect();
		 
	   }, 60000); // Reconnect after no data received for 1 minute
	   
	   
	};
   
   
   
	// Socket error ///////////////////////////////////////////////////
	socket.onerror = function(err) {
		
	$(".status").text("Error").css("color", "red");
	
	console.log('Socket encountered error: ', err.message, 'Closing socket');
	
	socket.close();
	
	};
	 
  
  
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


