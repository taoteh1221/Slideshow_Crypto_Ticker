
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com



// Application version
var app_version = '3.10.0';  // 2022/JULY/21ST


// BLANK var inits
var api = [];
var sockets = [];
var rest_ids = [];
var rest_other = [];
var markets = [];
var parsed_markets = [];
var subscribe_msg = [];
var trade_side_price = [];
var trade_side_arrow = [];
var markets_length = 0;
var reload_queued = false;
var reload_countdown = -1;
// BELOW MUST at least be set as 'undefined' here
var api_alert; 
var kucoin_alert; 
var is_online;
// END BLANK var inits

// Save what time the app started running (works fine with refresh)
var runtime_start = new Date().getTime(); 

// Minimum-allowed error refresh time (if significant error requires refresh, to try auto-fixing it)
var min_error_refresh_time = Number(auto_error_fix_min * 60000); // (minutes to milliseconds)

// REST API REFRESH TIME
var rest_api_refresh_milliseconds = Number(rest_api_refresh * 60000); // (minutes to milliseconds)

// UPGRADE CHECK REFRESH TIME
var upgrade_api_refresh_milliseconds = Number(upgrade_api_refresh * 3600000); // (hours to milliseconds)

//////////////////////////////////////////////////////////////////////////////////////

// Load external google font CSS file if required
var google_font_css = load_google_font();

//////////////////////////////////////////////////////////////////////////////////////


// Initiate once page is fully loaded...
$(document).ready(function() {

is_online = navigator.onLine; // Internet status
    
upgrade_check(); // Start checking for upgrades

system_info_js(); // System info (temp , memory used, etc)

// Change color on top area to help prevent screen burn
// (besides the slow back-and-forth we also do for that area)
change_color('system_data');
change_color('upgrade_alert');


    // Event listeners for internet status updates

    window.addEventListener("offline", function() {
    console.log('Internet is offline.');
    is_online = false;
    reload_queued = true;
    $("#internet_alert").css({ "display": "block" });
    $("#internet_alert").text("Internet offline!").css("color", "#fc4e4e"); 
    });
    

    window.addEventListener("online", function() {
        
        // Only run logic if we were offline LAST CHECK
        if ( is_online == false ) {
        
        is_online = true;   
            
        console.log('Internet is back online.');
        
        $("#internet_alert").css({ "display": "block" });
        $("#internet_alert").html("Internet back online, reloading...<br />(in " + app_reload_wait + " seconds)").css("color", "#ffff00");        
        
        reload_check();
            
        }
        
    });
	
	
	// Touch / click to see 'tooltip' formatted upgrade description
	$("#upgrade_alert").click(function() {
	    
	var opposite_click = false;
	
	var selected_text = window.getSelection().toString(); 
	
	//console.log(selected_text);
  
    var $title = $(this).find(".title");
  
        if (!$title.length) {
        $(this).append('<span class="title">' + nl2br( window.latest_version_description ) + '</span>');
        }
        else {
            
            $( "#upgrade_alert" ).contextmenu(function() {
            //console.log("opposite clicked");
            var opposite_click = true;
            }); 
            
            if ( !opposite_click && selected_text == '' ) {
            $title.remove();
            }
            else if ( !opposite_click && selected_text != '' ) {
            document.execCommand("Copy");
	        alert('Copied to clipboard.');
            }
            
        }
        
    });
    

	// Custom google font
	if ( google_font_css == false ) {
	console.log('Skipping custom google font rendering (no value set).');
	}
	else {
	console.log('Enabling custom google font rendering.');
	$("body, html").css({ "font-family": google_font_css });
	}


	// If monospace emulation is properly enabled, set the CSS attributes
	if ( monospace_check() == true ) {
	console.log('Enabling monospace emulation rendering.');
	$(".ticker .monospace").css({ "width": Math.round(ticker_size * monospace_width) + "px" });
	$(".volume .monospace").css({ "width": Math.round(volume_size * monospace_width) + "px" });
	}
	else {
	console.log('Skipping monospace emulation rendering (no proper decimal value of 1.00 or less detected).');
	}
	

	// Screen orientation
	if ( orient_screen > 0 ) {
	$("#ticker_window").addClass("orient_" + orient_screen);
	}



// Background color
$("body, html").css({ "background": background_color });

// Text color
$("body, html").css({ "color": text_color });

// Raspi data text size
$("#system_data").css({ "font-size": system_data_size + 'vw' });


// Connect to exchange APIs for market data, run checks, and load the interface
init_interface();


});


//////////////////////////////////////////////////////////////////////////////////////



