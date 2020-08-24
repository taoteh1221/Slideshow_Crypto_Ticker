
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com


//////////////////////////////////////////////////////////////////////////////////////


// Var inits
var sockets = [];
var markets = [];
var parsed_markets = [];
var subscribe_msg = [];
var trade_side_price = [];
var trade_side_arrow = [];
var markets_length = 0;


// Exchange API endpoints
sockets['binance'] = new WebSocket('wss://stream.binance.com:9443/ws');

sockets['coinbase'] = new WebSocket('wss://ws-feed.gdax.com');

sockets['kraken'] = new WebSocket('wss://ws.kraken.com');

sockets['hitbtc'] = new WebSocket('wss://api.hitbtc.com/api/2/ws');


// Put configged markets into a multi-dimensional array, calculate number of markets total
Object.keys(exchange_markets).forEach(function(exchange) {
	
	if ( markets[exchange] != '' ) {
	markets[exchange] = exchange_markets[exchange].split("|");
	markets_length = markets_length + markets[exchange].length;
	}
		
});


///////////////////////////////////////////////////////////////////////////////////////


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
  // Binance
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

  
//console.log(subscribe_msg[exchange]);

});


//////////////////////////////////////////////////////////////////////////////////////



