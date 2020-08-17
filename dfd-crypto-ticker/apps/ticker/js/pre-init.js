
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com


//////////////////////////////////////////////////////////////////////////////////////

var trade_side_price = [];
var trade_side_arrow = [];

// Auto-correct basic config user input errors
crypto_exchange = crypto_exchange.trim();
crypto_exchange = crypto_exchange.toLowerCase();
crypto_exchange = crypto_exchange.replace(/\s/g, "");


// Put configged markets into an array
var markets = crypto_markets.split("|");


///////////////////////////////////////////////////////////////////////////////////////


if ( crypto_exchange == 'coinbase' ) {
	
// API call config
var subscribe_msg = {
      
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
	markets.forEach(element => {
	subscribe_msg.product_ids[loop] = element;
	loop = loop + 1;
	});

//console.log(subscribe_msg);

}
else if ( crypto_exchange == 'binance' ) {
	
// API call config
var subscribe_msg = {
  "method": "SUBSCRIBE",
  "params": [
  ],
  "id": 1
};
 
 
	// Add markets to API call
	var loop = 0;
	markets.forEach(element => {
	subscribe_msg.params[loop] = element + '@ticker'; 
	loop = loop + 1;
	});

//console.log(subscribe_msg);

}


//////////////////////////////////////////////////////////////////////////////////////



