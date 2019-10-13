
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com



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


// Initiate once page is fully loaded...
$(document).ready(function() {


// Title font size
$(".title").css({ "font-size": title_size + "px" });

// Ticker font size
$(".ticker").css({ "font-size": ticker_size + "px" });

// Volume font size
$(".volume").css({ "font-size": volume_size + "px" });

// Bottom margin
$("#ticker_window").css({ "padding-bottom": bottom_margin + "px" });


	// Screen orientation
	if ( orient_screen == 'flip' ) {
	$("#ticker_window").addClass("flip");
	}


// Start ticker
ticker_init();
	
	
	// If more than one asset, run in slideshow mode (with delay of slideshow_speed seconds)
	if ( window.markets.length > 1 ) {
	setInterval(ticker_init, slideshow_speed * 1000);
	}


// Connect to API
api_connect();
	
	
});


//////////////////////////////////////////////////////////////////////////////////////



