
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com





//////////////////////////////////////////////////////////////////////////////////////



// Put configged markets into an array
var markets = crypto_markets.split("|");


///////////////////////////////////////////////////////////////////////////////////////


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



//////////////////////////////////////////////////////////////////////////////////////



