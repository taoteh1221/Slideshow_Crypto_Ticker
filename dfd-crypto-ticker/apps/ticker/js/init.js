
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com




//////////////////////////////////////////////////////////////////////////////////////

// Load external google font CSS file if required
var google_font_css = load_google_font();

//////////////////////////////////////////////////////////////////////////////////////


// Initiate once page is fully loaded...
$(document).ready(function() {



	// Custom google font
	if ( google_font_css == false ) {
	console.log('Skipping custom google font rendering (no value set).');
	}
	else {
	console.log('Enabling custom google font rendering.');
	$("body, html").css({ "font-family": google_font_css });
	}


	// Monospace emulation
	if ( monospace_check() == true ) {
	console.log('Enabling monospace emulation rendering.');
	$(".ticker .monospace").css({ "width": Math.round(ticker_size * monospace_width) + "px" });
	$(".volume .monospace").css({ "width": Math.round(volume_size * monospace_width) + "px" });
	}
	else {
	console.log('Skipping monospace emulation rendering (no proper decimal value of 1.00 or less detected).');
	}
	

	// Screen orientation
	if ( orient_screen == 'flip' ) {
	$("#ticker_window").addClass("flip");
	}


	
// Title font size
$(".title").css({ "font-size": title_size + "px" });

// Ticker font size
$(".ticker").css({ "font-size": ticker_size + "px" });

// Volume font size
$(".volume").css({ "font-size": volume_size + "px" });

// Bottom margin
$("#ticker_window").css({ "top": vertical_position + "px" });

// Background color
$("body, html").css({ "background": background_color });

// Text color
$("body, html").css({ "color": text_color });


// Start ticker
ticker_init();
	
	
	// If more than one asset, run in slideshow mode (with delay of slideshow_speed seconds)
	if ( window.markets.length > 1 ) {
		
		// If auto mode for slideshow speed
		if ( slideshow_speed == 0 ) {
		slideshow_speed = Math.round(60 / window.markets.length);
		}
		
	setInterval(ticker_init, slideshow_speed * 1000);
	
	}


// Connect to API
api_connect();
	
	
});


//////////////////////////////////////////////////////////////////////////////////////



