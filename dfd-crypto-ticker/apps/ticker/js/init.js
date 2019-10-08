
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com


// Put configged markets into an array
var markets = crypto_markets.split("|");


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




$(document).ready(function() {


	// Flipped screen
	if ( screen_position == 'flip' ) {
	$("#ticker_window").addClass("flip");
	}


	// Start ticker slideshow
	if ( window.markets.length > 1 ) {
	div_slideshow();
	setInterval(div_slideshow, slideshow_speed * 1000);
	}
	else {
	div_slideshow();
	}


// Connect to API
api_connect();
	
	
});