function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

    $(document).ready(function() {
  var socket = new WebSocket("wss://ws-feed.gdax.com");
  socket.onopen = function() {
    var msg = {
      type: "subscribe",
      product_id: "BTC-USD"
    };
    socket.send(JSON.stringify(msg));
    console.log(msg);
    $("#status").text("Coinbase").css("color", "#2bbf2b");
  };

  socket.onmessage = function(event) {
    var msg = JSON.parse(event.data);
    if (msg["type"] == "match") {
    	
      var price = parseFloat(msg["price"]).toFixed(2);
		
      var sign;
      if (msg["side"] == "sell") {
        sign = "▲";
      } else {
        sign = "▼";
      }
      var time = new Date();
      var hours = time.getHours();
      var minutes = time.getMinutes();
      var seconds = time.getSeconds();
      if (hours > 12) {
        hours = hours - 12;
      } else if (hours == 0) {
        hours = 12;
      }
      if (hours < 10) {
        hours = "0" + hours;
      }
      if (minutes < 10) {
        minutes = "0" + minutes;
      }
      if (seconds < 10) {
        seconds = "0" + seconds;
      }

      var fulltime = hours + ":" + minutes + ":" + seconds;
      var side = '"' + msg["side"] + '"';
      var price_list_item =
        "<div class='spacing'><span class=" +
        side +
        ">" +
        sign +
        "</span> <span class='tick'>$" +
        numberWithCommas(price) +
        "</span></div><div class='spacing'>(" +
        fulltime +
        ")" +
        "</div>";

      $("#ticker").html(price_list_item);
    }
  };

  function sendText() {
    var msg = {
      type: "subscribe",
      product_id: "BTC-USD"
    };
    socket.send(JSON.stringify(msg));
  }
});

