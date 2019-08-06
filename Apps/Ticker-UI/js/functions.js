
/////////////////////////////////////////////////////////////////////////////////////////////////////

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

function sendText() {
    var msg = {
      type: "subscribe",
      product_id: "BTC-USD"
    };
    socket.send(JSON.stringify(msg));
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

function connect() {
  var socket = new WebSocket('wss://ws-feed.gdax.com');
  socket.onopen = function() {
    var msg = {
      
    "type": "subscribe",
    "product_ids": [
        "BTC-USD"
    ],
    "channels": [
        {
            "name": "ticker",
            "product_ids": [
                "BTC-USD"
            ]
        }
    ]
    };
    socket.send(JSON.stringify(msg));
    //console.log(msg);
    $("#status").text("Coinbase").css("color", "#2bbf7b");
  };

  socket.onmessage = function(e) {
    var msg = JSON.parse(event.data);
    //console.log(msg);
    if (msg["type"] == "ticker") {
    	
      var price = parseFloat(msg["price"]).toFixed(2);
      var usd_volume = price * parseFloat(msg["volume_24h"]);
      usd_volume = usd_volume.toFixed(0);
		
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
        "</span> <span class='tick'>$" +
        numberWithCommas(price) +
        "</span></div><div class='spacing small'>(24hr Vol: $" +
        numberWithCommas(usd_volume) +
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


