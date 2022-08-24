
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com




/////////////////////////////////////////////////////////////////////////////////////////////////////


const rgb2hex = (rgb) => `#${rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/).slice(1).map(n => parseInt(n, 10).toString(16).padStart(2, '0')).join('')}`


/////////////////////////////////////////////////////////////////////////////////////////////////////


function nl2br(str){
 return str.replace(/(?:\r\n|\r|\n)/g, '<br>');
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function uc_first(input) { 
return input[0].toUpperCase() + input.slice(1); 
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function reload_js(src_file) {
remove_jscss_file(src_file, 'js');
load_js(src_file + '?cachebuster='+ new Date().getTime() );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


var count_decimals = function (value) {
    if(Math.floor(value) === value) return 0;
    return value.toString().split(".")[1].length || 0; 
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function is_json(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function system_info_js() {
    
    if ( show_system_data == 'on' ) {
        
    reload_js('cache/system-info.js'); // System info
    
        // Rerun system_info_js() again after 65000 milliseconds (65 seconds)
        setTimeout(function() {
        system_info_js();
        }, 65000); 
        
    }

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function valid_endpoint(exchange) {

	// Skip, if no endpoint or markets are set for this exchange
	if ( typeof api[exchange] == 'undefined' || api[exchange].trim() == '' ) {
	console.log(exchange + ' endpoint not defined, removing it\'s market config...');
	markets[exchange] = '';
	return false;
	}
	else {
	return true;
	}

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function js_safe_key(key, exchange) {

key = key.replace("/", "-"); // So we only have to regex a hyphen
key = key.replace(":", "-"); // So we only have to regex a hyphen
key = key.replace(/-/g, "") + '_key_' + exchange;
key = key.toLowerCase();

	// To assure appropriate ticker updated
	if ( key ) {
	return key;
	}
	else {
	return false;
	}

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function remove_jscss_file(filename, filetype) {
    
var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none" //determine element type to create nodelist from
var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none" //determine corresponding attribute to test for
var allsuspects=document.getElementsByTagName(targetelement)
    
    for ( var i=allsuspects.length; i>=0; i-- ) { //search backwards within nodelist for matching elements to remove
    
        if (
        allsuspects[i] 
        && allsuspects[i].getAttribute(targetattr) != null 
        && allsuspects[i].getAttribute(targetattr).indexOf(filename) != -1
        ) {
        allsuspects[i].parentNode.removeChild(allsuspects[i]) //remove element by calling parentNode.removeChild()
        }
        
    }
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function arrow_html() {

arrow_height = Math.round(ticker_size * arrow_size);
arrow_width = Math.round(arrow_height * 0.84);
arrow_border_width = Math.round(arrow_width / 2);
	
// Arrow height
$("div.arrow_wrapper").css({ "height": arrow_height + "px" });
$("span.buy").css({ "border-bottom": arrow_height + "px solid rgb(105, 199, 115)" });
$("span.sell").css({ "border-top": arrow_height + "px solid rgb(199, 105, 105)" });

// Arrow width
$("div.arrow_wrapper").css({ "width": arrow_width + "px" });
$("span.arrow").css({ "border-left": arrow_border_width + "px solid transparent" });
$("span.arrow").css({ "border-right": arrow_border_width + "px solid transparent" });

// Arrow right-side spacing
$("div.arrow_wrapper").css({ "margin-right": arrow_spacing + 'px' });

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function console_alert() {
    
    if  ( window.api_alert == 1 ) {
    return;
    }
    else {
	window.api_alert = 1; 
    }

console.log(' ');
console.log('IMPROPER APP INSTALLATION DETECTED!');
console.log(' ');
console.log('To have access to ALL the features in this app, please make sure you have done ALL of the following...');
console.log(' ');
console.log('1) Open the "Terminal" app in your operating system interface menu, or login via remote terminal, AS THE USER YOU WANT RUNNING THE APP (user must have sudo privileges).');
console.log(' ');
console.log('2) In the terminal, copy / paste / run this command, THEN REBOOT when finished installing the app:');
console.log('wget --no-cache -O TICKER-INSTALL.bash https://tinyurl.com/install-crypto-ticker;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash');
console.log(' ');
console.log('3) ON REBOOT / TICKER STARTUP, you are logged-in to the GRAPHICAL DESKTOP INTERFACE, #AND# are running the app as the SAME USER YOU INSTALLED AS.');
console.log(' ');

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function copy_text(elm) {

  // for Internet Explorer
  if(document.body.createTextRange) {
    range = document.body.createTextRange();
    range.moveToElementText(elm);
    range.select();
    document.execCommand("Copy");
	 alert('Copied to clipboard.');
  }
  // other browsers
  else if(window.getSelection) {
    selection = window.getSelection();
    range = document.createRange();
    range.selectNodeContents(elm);
    selection.removeAllRanges();
    selection.addRange(range);
    document.execCommand("Copy");
	 alert('Copied to clipboard.');
  }
  
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function change_color(id) {

hex_color = rgb2hex( $("#" + id).css('color') );
    
    if ( typeof hex_color != 'undefined' ) {
    
        // Switch back and forth between yellow / cyan
        if ( hex_color == '#ffff00' ) {
        new_color = "#00ffff";
        }
        else {
        new_color = "#ffff00";
        }
    
    $("#" + id).css("transition", "color 30.0s").css('color', new_color);
    
        // Rerun change_color() again after 30 seconds
        setTimeout(function() {
        change_color(id);
        }, 30000);  
    
    }

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function load_js(file) {

script= document.createElement('script');
script.src= file;

// Defer seems better for letting everything load without it:
// https://flaviocopes.com/javascript-async-defer/
// https://medium.com/swlh/async-defer-and-dynamic-scripts-9a2c43a92be1
script.defer = true;
script.async = false;

head = document.getElementsByTagName('head')[0];
head.appendChild(script);

   script.onload = function(){
       
       if ( debug_mode == 'on' ) {
       console.log('Loaded JS file: ' + file);
       }
       
   };
    
   
   // List all loaded js scripts in debug mode
   // (to double-check we are not double-loading when we reload a script)
   if ( debug_mode == 'on' ) {
   
   scripts = document.getElementsByTagName('script');

        for(var i=0;i<scripts.length;i++){
        console.log(scripts[i].src);
        }    
    
   }

}


/////////////////////////////////////////////////////////////


function init_interface() {

console.log('init_interface'); // DEBUGGING

// Load kucoin.js dynamically, avoiding loading from the browser cache (lol, cachefest), via a timestamp url param
script= document.createElement('script');
script.src= 'cache/kucoin.js?cachebuster='+ new Date().getTime();

head = document.getElementsByTagName('head')[0];
head.appendChild(script);
	
	
	// If script loads OK
	script.onload = function(){
	console.log('JS cache file loaded successfully (valid installation detected).');
	render_interface();
    };

	
	// If script loading FAILS
	script.onerror = function(){
	console.log('JS cache file not found (invalid installation detected).');
	render_interface();
    };

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function monospace_check() {
	
check = monospace_width;


  // Not a number check
  if ( isNaN(check) ) {
  return false;
  }


// Second number check, with check for decimals with value of 1.00 or less
var result = (check - Math.floor(check)) !== 0; 
   
   
  if (result) { // Is a decimal number
  
  	if ( monospace_width > 1 ) { // Is greater than 1.00
  	return false;
  	}
  	else { // Is NOT greater than 1.00
  	return true;
  	}
  	
  }
  else { // Is not a decimal number
  return false;
  }
     
     
 }


/////////////////////////////////////////////////////////////////////////////////////////////////////


function number_commas(num, min_decimals, max_decimals) {
	
//console.log(typeof num);
	
	if ( num >= 1 ) {
		
		if ( typeof num == 'string' ) {
		
			num = parseFloat(num).toLocaleString(undefined, {
   		    minimumFractionDigits: min_decimals,
   		    maximumFractionDigits: max_decimals
			});
		
		}
		else {
		
			num = num.toLocaleString(undefined, {
   		    minimumFractionDigits: min_decimals,
   		    maximumFractionDigits: max_decimals
			});
		
		}
	
	}


return num;
   
}
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////


function render_names(name) {
	
render = name.charAt(0).toUpperCase() + name.slice(1);

render = render.replace(/usd/gi, "USD");
render = render.replace(/eur/gi, "EUR");
render = render.replace(/gbp/gi, "GBP");
render = render.replace(/btc/gi, "BTC");
render = render.replace(/eth/gi, "ETH");
render = render.replace(/sol/gi, "SOL");
render = render.replace(/nft/gi, "NFT");
render = render.replace(/coin/gi, "Coin");
render = render.replace(/bitcoin/gi, "Bitcoin");
render = render.replace(/exchange/gi, "Exchange");
render = render.replace(/market/gi, "Market");
render = render.replace(/forex/gi, "Forex");
render = render.replace(/finex/gi, "Finex");
render = render.replace(/stamp/gi, "Stamp");
render = render.replace(/flyer/gi, "Flyer");
render = render.replace(/panda/gi, "Panda");
render = render.replace(/pay/gi, "Pay");
render = render.replace(/swap/gi, "Swap");
render = render.replace(/iearn/gi, "iEarn");
render = render.replace(/pulse/gi, "Pulse");
render = render.replace(/defi/gi, "DeFi");
render = render.replace(/loopring/gi, "LRing");
render = render.replace(/amm/gi, "AMM");
render = render.replace(/ico/gi, "ICO");
render = render.replace(/erc20/gi, "ERC-20");
render = render.replace(/okex/gi, "OKex");
render = render.replace(/mart/gi, "Mart");
render = render.replace(/ftx/gi, "FTX");
render = render.replace(/gateio/gi, "Gate.io");
render = render.replace(/coingecko/gi, "CGecko");
render = render.replace(/dex/gi, "DEX");

return render;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function monospace_rendering($element) {
	
	if (  typeof $element !== 'undefined' ) {
	
    for (var i = 0; i < $element.childNodes.length; i++) {
    
    var $child = $element.childNodes[i];

        if ($child.nodeType === Node.TEXT_NODE) {
        	
        var $wrapper = document.createDocumentFragment();

            for (var i = 0; i < $child.nodeValue.length; i++) {
            	
            	if ( isNaN($child.nodeValue.charAt(i)) || $child.nodeValue.charAt(i) == ' ' ) { // Space not detected well here, lol...so we work-around
                var $char = document.createElement('span');
                $char.textContent = $child.nodeValue.charAt(i);
                }
                else {
                var $char = document.createElement('span');
                $char.className = 'monospace';
                $char.textContent = $child.nodeValue.charAt(i);
                }

            $wrapper.appendChild($char);
                
            }

        $element.replaceChild($wrapper, $child);
        
        } 
        else if ($child.nodeType === Node.ELEMENT_NODE) {
        monospace_rendering($child);
        }
        
    }
    
   }
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_html(market_id, exchange) {
	
parsed_market_id = market_id_parser(market_id, exchange);
				 
asset = parsed_market_id.asset;
		
pairing = parsed_market_id.pairing;
  
market_key = js_safe_key(market_id, exchange);

	
	// To assure appropriate ticker updated
	if ( typeof market_key !== 'undefined' ) {

	html = '<div id="wrapper_' + market_key + '" class="asset_tickers">'+
    
	'<div class="title" style="font-size: '+title_size+'px; font-weight: '+font_weight+';"><span id="asset_' + market_key + '">' + asset + '</span> <span class="status_wrapper_'+exchange+'"><span class="parenth_'+market_key+'">(<span class="status status_'+exchange+' status_'+market_key+'">Loading</span>)</span></span></div>'+
	
	'<div class="ticker" style="font-size: '+ticker_size+'px; font-weight: '+font_weight+';" id="ticker_' + market_key + '"></div>'+
    
	'<div class="volume" style="font-size: '+volume_size+'px; font-weight: '+font_weight+';" id="volume_' + market_key + '"></div>'+
	
	'</div>';
	
	$(html).appendTo( "#ticker_window" );
	
	}
	else {
	return false;
	}


}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function load_google_font() {
	
config_font = google_font;

	// Skip custom font rendering if no config value
	if ( config_font == null ) {
	return false;
	}

formatted_link = config_font.split(' ').join('+');


// Get HTML head element 
head = document.getElementsByTagName('HEAD')[0];  
  
// Create new link Element 
link = document.createElement('link'); 
  
// set the attributes for link element  
link.rel = 'stylesheet';  
      
link.type = 'text/css'; 
      
link.href = 'https://fonts.googleapis.com/css?family=' + formatted_link + '&display=swap';  

// Append link element to HTML head 
head.appendChild(link); 

// DEBUGGING
//console.log("google_font = " + config_font);
//console.log("Formatted for CSS link: " + formatted_link);
console.log("Google font CSS href link set as: " + link.href);

return "'" + config_font + "', serif, monospace";

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function ticker_init() {

	
ticker_divs = $('#ticker_window div.asset_tickers');


	// Slideshow init
	if ( typeof window.slideshow_init == 'undefined' ) {
	this_ticker = ticker_divs.first();
	window.slideshow_init = 1;
	}
	// Slideshow continue
	else {
	this_ticker = window.ticker_next;
	window.slideshow_init = 0;
	}


t_speed = Math.round(window.transition_speed * 1000);


   // If more than one market, run slideshow
	if ( markets_length > 1 ) {

	window.ticker_next = this_ticker.next().length ? this_ticker.next() : ticker_divs.first();

		// Slideshow init
		if ( window.slideshow_init == 1 ) {
		this_ticker.fadeIn(t_speed);
		}
		// Slideshow continue
		else {
			
		ticker_prev = this_ticker.prev().length ? this_ticker.prev() : ticker_divs.last();
			
   		    ticker_prev.fadeOut(t_speed, function() {
   		    this_ticker.fadeIn(t_speed);
			});
		
		}
	
   }
   // If just one market, leave showing
   else if ( markets_length == 1 ) {
   this_ticker.fadeIn(t_speed);
   }
	
   
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


// https://gist.github.com/jiggzson/b5f489af9ad931e3d186
var scientificToDecimal = function (num) {
    var nsign = Math.sign(num);
    //remove the sign
    num = Math.abs(num);
    //if the number is in scientific notation remove it
    if (/\d+\.?\d*e[\+\-]*\d+/i.test(num)) {
        var zero = '0',
                parts = String(num).toLowerCase().split('e'), //split into coeff and exponent
                e = parts.pop(), //store the exponential part
                l = Math.abs(e), //get the number of zeros
                sign = e / l,
                coeff_array = parts[0].split('.');
        if (sign === -1) {
            l = l - coeff_array[0].length;
            if (l < 0) {
              num = coeff_array[0].slice(0, l) + '.' + coeff_array[0].slice(l) + (coeff_array.length === 2 ? coeff_array[1] : '');
            } 
            else {
              num = zero + '.' + new Array(l + 1).join(zero) + coeff_array.join('');
            }
        } 
        else {
            var dec = coeff_array[1];
            if (dec)
                l = l - dec.length;
            if (l < 0) {
              num = coeff_array[0] + dec.slice(0, l) + '.' + dec.slice(l);
            } else {
              num = coeff_array.join('') + new Array(l + 1).join(zero);
            }
        }
    }

    return nsign < 0 ? '-'+num : num;
};


/////////////////////////////////////////////////////////////////////////////////////////////////////


function dyn_max_decimals(price_raw) {
    
    
    if ( ticker_round_percent == 'one' ) {
    x = 1;
    }
    else if ( ticker_round_percent == 'tenth' ) {
    x = 0.1;
    }
    else if ( ticker_round_percent == 'hundredth' ) {
    x = 0.01;
    }
    else if ( ticker_round_percent == 'thousandth' ) {
    x = 0.001;
    }
    
    
unit_percent = (price_raw / 100) * x;

    
    // 8 decimals rounding
    if ( unit_percent <= 0.00000005 ) {
    decimals = 8;
    }
    // 7 decimals rounding
    else if ( unit_percent <= 0.0000005 ) {
    decimals = 7;
    }
    // 6 decimals rounding
    else if ( unit_percent <= 0.000005 ) {
    decimals = 6;
    }
    // 5 decimals rounding
    else if ( unit_percent <= 0.00005 ) {
    decimals = 5;
    }
    // 4 decimals rounding
    else if ( unit_percent <= 0.0005 ) {
    decimals = 4;
    }
    // 3 decimals rounding
    else if ( unit_percent <= 0.005 ) {
    decimals = 3;
    }
    // 2 decimals rounding
    else if ( unit_percent <= 0.05 ) {
    decimals = 2;
    }
    // 1 decimals rounding
    else if ( unit_percent <= 0.5 ) {
    decimals = 1;
    }
    // 0 decimals rounding
    else {
    decimals = 0;
    }
    

    // Use min/max decimals if applicable  (from user config)
    if ( decimals > ticker_max_decimals ) {
    return ticker_max_decimals;
    }
    else if ( decimals < ticker_min_decimals ) {
    return ticker_min_decimals;
    }
    else {
    return decimals;
    }
    

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function reload_check() {


                // Reload IS queued
                if ( reload_queued == true ) {
                    
                console.log('App reload countdown started...');
                    
                // Set reload_countdown with config.js value 
                // (we don't want to use directly and overwrite user settings during countdown)
    			reload_countdown = app_reload_wait; 
    			
                	window.reload_logic = setInterval(function () {
                	
                	        // Cancel any running reload countdown logic (internet back offline, etc)
                	        if ( is_online == false ) {
		                    clearInterval(window.reload_logic); 
                            reload_countdown = -1; // Reset to default
                            console.log('App reload canceled.');
                	        return;
                	        }
                	        
            				
            				if ( reload_countdown > 0 ) {
                            $("#internet_alert").html("Internet back online, reloading...<br />(in " + reload_countdown + " seconds)").css("color", "#ffff00");
            				}
            				else if ( reload_countdown === 0 ) {
                            reload_queued = false; // Just for clean / readable code's sake
                 		    location.reload(true); // Full reload (NOT from cache)
            				}
                
                 	reload_countdown-- || clearInterval(reload_countdown);  // Clear if 0 reached
                 
                 	}, 1000);
                   
                }
                // Reload NOT queued
                else {
                    
                    // Cancel any running reload countdown logic (internet back offline, etc)
            		if ( window.reload_logic ) {
            		clearInterval(window.reload_logic); 
            		}

                reload_countdown = -1; // Reset to default
                console.log('App reload canceled.');
                return;
                
                }


}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function render_interface() {

console.log('render_interface'); // DEBUGGING


    // If we already setup the market configs
    if ( Object.keys(markets).length > 0 ) {
    console.log('market_config was already setup, skipping.');
    }
    // If offline
    else if ( market_config() == 'offline' ) {
    reload_queued = true;
    console.log('No internet connection, interface rendering stopped...');
    $("#internet_alert").css({ "display": "block" });
    $("#internet_alert").text("Internet Offline!").css("color", "#fc4e4e"); 
    return;
    }
    
        
	// Connect to exchange APIs for market data
	// Render the HTML containers for each ticker
	Object.keys(markets).forEach(function(exchange) {
                
		
			if ( markets[exchange] != '' ) {
                
    			if ( exchange == 'coingecko' ) {
    		    rest_connect(exchange);
    		    }
    		    else {
    		    websocket_connect(exchange);
    		    }
			
  				markets[exchange].forEach(element => {
  				ticker_html(element, exchange);
				});
			
			}
			
		
	});

		
		
	// Start ticker
	// More than one asset, so run in slideshow mode (with delay of slideshow_speed seconds)
	if ( markets_length > 1 ) {
			
			// If auto mode for slideshow_speed (minimum of 5 seconds allowed)
			if ( slideshow_speed == 0 ) {
			slideshow_speed = Math.round(60 / window.markets_length);
			slideshow_speed = slideshow_speed < 5 ? 5 : slideshow_speed;
			}
			
		setInterval(ticker_init, slideshow_speed * 1000);
		
	}
	// If only one market
	else if ( markets_length == 1 ) {
	ticker_init();
	}
    

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function update_ticker(update_key, market_id, asset, pairing, price_raw, base_volume, exchange=false) {
				 
price_raw = scientificToDecimal(price_raw); // Convert scientific format to string (decimals), if needed

   
   // Show or hide exchange / api status
   if ( exchange != false ) {
	
	   // Using ".status_" + update_key INSTEAD, TO SHOW PER-ASSET 
       if ( price_raw == 0 ) {
       $(".parenth_" + update_key).css({ "display": "inline" });
       $(".status_" + update_key).text("Loading").css("color", "#ffff00");
       return;
       }
       else if ( show_exchange_name == 'off' ) {
       $(".parenth_" + update_key).css({ "display": "none" });
       }
       else if ( price_raw >= 0.00000001 ) {
       $(".parenth_" + update_key).css({ "display": "inline" });
       $(".status_" + update_key).text( render_names(exchange) ).css("color", "#2bbf7b");
       }
   
   }
                       
            		
trade_side = trade_type(price_raw, market_id);
        		 
market_info = asset_symbols(pairing);
        		 
market_symbol = market_info['asset_symbol'];
        			
// Determine decimals [IF NEEDED, this is set to ticker_min_decimals OR ticker_max_decimals ALREADY in dyn_max_decimals()]
set_max_decimals = dyn_max_decimals(price_raw, market_info);
        	
        			
    // Set minimum decimals
    // If FIAT value under 100, AND IF set_max_decimals is less than or equal to 2,
    // then force 2 FIXED decimals ALWAYS for #FIAT VALUES# UX
    if ( price_raw < 100 && market_info['asset_type'] == 'fiat' && set_max_decimals <= 2 ) {
    set_max_decimals = 2; // For number_commas() logic (#MUST# BE RESET HERE TOO, #CANNOT# BE LESS THAN THE MINIMUM!!)
    set_min_decimals = 2; // For number_commas() logic
    }
    // If DYNAMIC fixed minimum decimals configured in user config
    // (ticker_min_decimals ALREADY CHECKED IN set_max_decimals [with dyn_max_decimals()])
    else if ( ticker_round_fixed_decimals == 'on' ) {
    set_min_decimals = set_max_decimals; // For number_commas() logic
    }
    // User config for min decimals used EVER (overrides ALL other fixed min decimal settings)
    else {
    set_min_decimals = ticker_min_decimals; // For number_commas() logic
    }


// Price with max decimals
price_rounded = parseFloat(price_raw).toFixed(set_max_decimals);

// ADDITIONALLY remove any TRAILING zeros in any decimals (for UX)
price = parseFloat(price_rounded);

    
    // IF we DID set using MINIMUM decimals, AND there are too few decimals in result
    if ( set_min_decimals > 0 && count_decimals(price) < set_min_decimals ) {
    price = price.toFixed(set_min_decimals);
    }
        			       			   
        				
// HTML for rendering
ticker_item =
      "<div class='spacing'><div class='arrow_wrapper' style=''><span class='arrow " +
      trade_side +
      "'></span></div><span class='tick_text'>" + market_symbol +
      number_commas(price, set_min_decimals, set_max_decimals) +
      "</span></div>";
        				 
        			
     // Volume logic
     if ( typeof base_volume !== 'undefined' ) {
        					
     volume_decimals = ( market_info['asset_type'] == 'crypto' ? 4 : 0 );
        				
     base_volume = Number(base_volume).toFixed(volume_decimals);
        				
     volume_item = 
       "<div class='spacing'>Vol: " + market_symbol +
       number_commas(base_volume, 0, volume_decimals) +
       "</div>";
        				
     }
     else {
        					
        if ( show_empty_volume == 'on' ) {
        volume_item = "<div class='spacing'>Vol: (not provided)</div>";
        }
        else {
        $("#volume_" + update_key).css({ "display": "none" });
        volume_item = "<div class='spacing'></div>";
        }
        					
     }
        				 
        				 
// Render data to appropriate ticker
        			
$("#ticker_" + update_key).html(ticker_item);
        			
arrow_html(); // #MUST BE# AFTER TICKER RENDERING ABOVE
        				
$("#volume_" + update_key).html(volume_item);
        				
        				
     // If monospace emulation is properly enabled, run it
     if ( monospace_check() == true ) {
        					
     monospace_rendering(document.querySelectorAll('#ticker_' + update_key)[0]);
        				
        if ( typeof base_volume !== 'undefined' ) {
        monospace_rendering(document.querySelectorAll('#volume_' + update_key)[0]);
        }
        					 
     }


}


/////////////////////////////////////////////////////////////////////////////////////////////////////


