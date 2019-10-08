
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



// Initiate once page is fully loaded...
$(document).ready(function() {


	// Flipped screen
	if ( screen_position == 'flip' ) {
	$("#ticker_window").addClass("flip");
	}


// Start ticker
div_slideshow();
	
	
	// If more than one asset, run slideshow (with delay of slideshow_speed seconds)
	if ( window.markets.length > 1 ) {
	setInterval(div_slideshow, slideshow_speed * 1000);
	}


// Connect to API
api_connect();
	
	
});