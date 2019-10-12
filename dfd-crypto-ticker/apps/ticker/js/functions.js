
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com



/////////////////////////////////////////////////////////////////////////////////////////////////////


function render_ticker(market) {
	
var asset = market.replace(/-[A-Za-z0-9]*/g, "");
var js_key = market.replace(/-/g, "");

document.write('<div class="asset_tickers">');

document.write('<div class="title"><span id="asset_' + js_key + '">' + asset + '</span> (<span class="status">Connecting...</span>)</div>');
    
document.write('<div class="ticker" id="ticker_' + js_key + '"></div>');
    
document.write('</div>');

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function div_slideshow() {
	
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
    $(".status").text("Coinbase").css("color", "#2bbf7b");
	});

    
  };

  socket.onmessage = function(e) {
  	
    var msg = JSON.parse(event.data);
    
    //console.log(msg);
    
    if (msg["type"] == "ticker") {
    	
    	var product_id = msg["product_id"];
    	
    	asset = product_id.replace(/-[A-Za-z0-9]*/g, "");
    	
    	pairing = product_id.replace(/\b([A-Za-z]*)-/g, "");
    	
    	var js_key = product_id.replace(/-/g, "");
    	
    	//console.log(asset);
    	//console.log(pairing);

			if ( pairing == 'USD' ) {
			var fiat_symbol = "$";
			}
			else if ( pairing == 'USDC' ) {
			var fiat_symbol = "Ⓢ";
			}
			else if ( pairing == 'EUR' ) {
			var fiat_symbol = "€";
			}
			else if ( pairing == 'GBP' ) {
			var fiat_symbol = "£";
			}
    	
		var decimals = msg["price"] >= 1 ? 2 : 6;
		
      var price = parseFloat(msg["price"]).toFixed(decimals);
      
      var fiat_volume = price * parseFloat(msg["volume_24h"]);
      
      fiat_volume = fiat_volume.toFixed(0);
		
      
      var side = msg["side"];
      
      var price_list_item =
        "<div class='spacing'><span class='arrow " +
        side +
        "'></span> <span class='tick'>" + fiat_symbol +
        numberWithCommas(price) +
        "</span></div><div class='spacing small'>(" + pairing + " Vol: " + fiat_symbol +
        numberWithCommas(fiat_volume) +
        ")" +
        "</div>";

      $("#ticker_" + js_key).html(price_list_item);
      
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


