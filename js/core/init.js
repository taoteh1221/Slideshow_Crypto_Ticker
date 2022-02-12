
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com



// Application version
var app_version = '3.08.0';  // 2022/FEBUARY/11TH


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
var min_error_refresh_time = Number(auto_error_fix_min * 60000); // (in milliseconds)

// REST API REFRESH TIME
var rest_api_refresh_milliseconds = Number(rest_api_refresh * 60000); // (in milliseconds)

//////////////////////////////////////////////////////////////////////////////////////

// Load external google font CSS file if required
var google_font_css = load_google_font();

//////////////////////////////////////////////////////////////////////////////////////


// Initiate once page is fully loaded...
$(document).ready(function() {

is_online = navigator.onLine; 


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
        $("#internet_alert").html("Internet back online, reloading...<br />(in " + app_reload_wait + " seconds)").css("color", "#FFFF00");        
        
        reload_check();
            
        }
        
    });

    
    // Upgrade checks
    if ( upgrade_notice == 'on' ) {
        
        
    	$.get( "https://api.github.com/repos/taoteh1221/Slideshow_Crypto_Ticker/releases/latest", function(data) {
    	    
    	var latest_version = data.tag_name;
    	
    	var latest_version_description = data.body;
    	
    	var latest_version_download = data.zipball_url;
    	
    	var latest_version_installer = "wget --no-cache -O TICKER-INSTALL.bash https://git.io/Jqzjk;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash";
    	
    	// Remove anything AFTER formatting in brackets in the description (including the brackets)
    	// (removes the auto-added sourceforge download link)
    	latest_version_description = latest_version_description.split('[')[0]; 
    	
    	latest_version_description = "Upgrade Description:\n\n" + latest_version_description.trim();
    	
    	latest_version_description = latest_version_description + "\n\nAutomatic install terminal command:\n\n" + latest_version_installer + "\n\n";
    	
    	window.latest_version_description = latest_version_description + "Manual Install File:\n\n" + latest_version_download + "\n\n(select all the text of either install method to auto-copy to clipboard)";
    	
    	
    	    if ( app_version != latest_version ) {
            $("#upgrade_alert").css({ "display": "block" });
            $("#upgrade_alert").html("<img id='upgrade_icon' src='images/upload-cloud-fill.svg' alt='' title='' /><span class='more_info' title=''>Upgrade available: v" + latest_version + "<br />(running v" + app_version + ")</span>").css("color", "#FFFF00"); 
    	    }
    	    
    	   
    	});
    	
	
	}
	
	
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


// Connect to exchange APIs for market data, run checks, and load the interface
init_interface();


});


//////////////////////////////////////////////////////////////////////////////////////



