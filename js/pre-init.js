
// Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com



//////////////////////////////////////////////////////////////////////////////////////


// Var inits
var api = [];
var sockets = [];
var markets = [];
var parsed_markets = [];
var subscribe_msg = [];
var trade_side_price = [];
var trade_side_arrow = [];
var markets_length = 0;


// Exchange API endpoints

// If kucoin auth data is cached, allow kucoin configs
if ( typeof kucoin_endpoint !== 'undefined' && typeof kucoin_token !== 'undefined' ) {
api['kucoin'] = kucoin_endpoint + '?token=' + kucoin_token;
}
// Remove kucoin market configs if no cache data is present, to avoid script errors,
// and alert (to console ONLY) that app was improperly installed
else {
delete exchange_markets['kucoin']; 
install_alert(); 
}

api['binance'] = 'wss://stream.binance.com:9443/ws';

api['coinbase'] = 'wss://ws-feed.gdax.com';

api['kraken'] = 'wss://ws.kraken.com';

api['hitbtc'] = 'wss://api.hitbtc.com/api/2/ws';

api['bitstamp'] = 'wss://ws.bitstamp.net/';

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

  
//console.log(subscribe_msg[exchange]);

});


//////////////////////////////////////////////////////////////////////////////////////



