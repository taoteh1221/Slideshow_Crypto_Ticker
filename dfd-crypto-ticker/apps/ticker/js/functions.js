
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com



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


function uc_first(input) { 

var string = input; 

return string[0].toUpperCase() + string.slice(1); 

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function numberWithCommas(x) {
	if ( x >= 1 ) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
   else {
   return x;
   }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function api_connect() {

	
var socket = new WebSocket('wss://ws-feed.gdax.com');
  
  socket.onopen = function() {

  socket.send(JSON.stringify(window.subscribe_msg));
    
  window.markets.forEach(element => {
  	var asset = element.replace(/-[A-Za-z0-9]*/g, "");
    $(".status").text( uc_first(window.crypto_exchange) ).css("color", "#2bbf7b");
	});

    
  };

  socket.onmessage = function(e) {
  	
    var msg = JSON.parse(e.data);
    
    //console.log(msg);
    
    if (msg["type"] == "ticker") {
    	
    	var product_id = msg["product_id"];
    	
    	asset = product_id.replace(/-[A-Za-z0-9]*/g, "");
    	
    	pairing = product_id.replace(/\b([A-Za-z]*)-/g, "");
    	
    	var js_key = product_id.replace(/-/g, "");
    	
    	//console.log(asset);
    	//console.log(pairing);


			// Unicode asset symbols
			if ( pairing == 'USD' ) {
			volume_symbol = "$";
			}
			else if ( pairing == 'EUR' ) {
			var volume_symbol = "€";
			}
			else if ( pairing == 'GBP' ) {
			var volume_symbol = "£";
			}
			else if ( pairing == 'BTC' ) {
			volume_symbol = "Ƀ ";
			}
			else if ( pairing == 'ETH' ) {
			volume_symbol = "Ξ ";
			}
			else if ( pairing == 'LTC' ) {
			volume_symbol = "Ł ";
			}
			else if ( pairing == 'USDC' || pairing == 'TUSD' ) {
			volume_symbol = "Ⓢ ";
			}
			else if ( pairing == 'USDT' ) {
			volume_symbol = "₮ ";
			}
			else if ( pairing == 'XMR' ) {
			volume_symbol = "ɱ ";
			}
    	
    	
		var price_decimals = msg["price"] >= 1 ? 2 : 6;
		
      var price = parseFloat(msg["price"]).toFixed(price_decimals);
      
		var volume_decimals = pairing == 'BTC' ? 2 : 0;
      
      var base_volume = price * parseFloat(msg["volume_24h"]);
      
      base_volume = base_volume.toFixed(volume_decimals);
		
      
      var side = msg["side"];
      
      var ticker_item =
        "<div class='spacing'><div class='arrow_wrapper'><span class='arrow " +
        side +
        "'></span></div><span class='tick_text'>" + volume_symbol +
        numberWithCommas(price) +
        "</span></div>";
        
      var volume_item = 
      	"<div class='spacing'>(" + pairing + " Vol: " + volume_symbol +
        numberWithCommas(base_volume) +
        ")" +
        "</div>";

      $("#ticker_" + js_key).html(ticker_item);
      $("#volume_" + js_key).html(volume_item);
      
    }
    
  };


  socket.onclose = function(e) {
    //console.log('Connecting', e.reason);
    setTimeout(function() {
    $(".status").text("Connecting").css("color", "red");
      api_connect();
    }, 60000); // Reconnect after no data received for 1 minute
  };


  socket.onerror = function(err) {
    $(".status").text("Error").css("color", "red");
    //console.error('Socket encountered error: ', err.message, 'Closing socket');
    socket.close();
  };
  
  
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


