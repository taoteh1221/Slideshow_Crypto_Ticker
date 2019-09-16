
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

function connect() {
	
	if ( window.currency_pairing == 'USD' || window.currency_pairing == 'USDC' ) {
	var fiat_symbol = "$";
	}
	else if ( window.currency_pairing == 'EUR' ) {
	var fiat_symbol = "€";
	}
	else if ( window.currency_pairing == 'GBP' ) {
	var fiat_symbol = "£";
	}
	
  var socket = new WebSocket('wss://ws-feed.gdax.com');
  

  
  socket.onopen = function() {
    var msg = {
      
    "type": "subscribe",
    "product_ids": [
        window.currency_crypto + "-" + window.currency_pairing
    ],
    "channels": [
        {
            "name": "ticker",
            "product_ids": [
                window.currency_crypto + "-" + window.currency_pairing
            ]
        }
    ]
    };
    socket.send(JSON.stringify(msg));
    //console.log(msg);
    $("#asset").text(window.currency_crypto);
    $("#status").text("Coinbase").css("color", "#2bbf7b");
  };

  socket.onmessage = function(e) {
    var msg = JSON.parse(event.data);
    //console.log(msg);
    if (msg["type"] == "ticker") {
    	
		var decimals = msg["price"] >= 1 ? 2 : 6;
      var price = parseFloat(msg["price"]).toFixed(decimals);
      var fiat_volume = price * parseFloat(msg["volume_24h"]);
      fiat_volume = fiat_volume.toFixed(0);
		
      var sign;
      if (msg["side"] == "sell") {
        sign = "▲";
      } else {
        sign = "▼";
      }
      var side = '"' + msg["side"] + '"';
      var price_list_item =
        "<div class='spacing'><span class=" +
        side +
        ">" +
        sign +
        "</span> <span class='tick'>" + fiat_symbol +
        numberWithCommas(price) +
        "</span></div><div class='spacing small'>(24hr Vol: " + fiat_symbol +
        numberWithCommas(fiat_volume) +
        ")" +
        "</div>";

      $("#ticker").html(price_list_item);
    }
  };

  socket.onclose = function(e) {
    //console.log('Connecting', e.reason);
    setTimeout(function() {
    $("#status").text("Connecting").css("color", "red");
      connect();
    }, 60000); // Reconnect after no data received for 1 minute
  };

  socket.onerror = function(err) {
    $("#status").text("Error").css("color", "red");
    //console.error('Socket encountered error: ', err.message, 'Closing socket');
    socket.close();
  };
}

/////////////////////////////////////////////////////////////////////////////////////////////////////


