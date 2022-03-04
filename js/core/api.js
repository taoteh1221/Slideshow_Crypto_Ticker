
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


/////////////////////////////////////////////////////////////


function kucoin_config() {
    
    if  ( window.kucoin_alert == 1 ) {
    return;
    }
    else {
	window.kucoin_alert = 1; 
    }
	
	// If kucoin auth data is cached, allow kucoin configs
	if ( typeof kucoin_endpoint !== 'undefined' && typeof kucoin_token !== 'undefined' ) {
	api['kucoin'] = kucoin_endpoint + '?token=' + kucoin_token;
	console.log('Kucoin support enabled (VALID installation detected).');
	return true;
	}
	// Remove kucoin market configs if no cache data is present, to avoid script errors,
	// and alert (to console ONLY) that app was improperly installed
	else {
	delete exchange_markets['kucoin'];
	console_alert(); 
	console.log('Kucoin support disabled (INVALID installation detected).');
	return false;
	}

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function kucoin_reload() {

// Force refresh the webpage from server (NOT cache), 
// if it's been at least 'min_error_refresh_time' since 'runtime_start'
error_detected_timestamp = Number( new Date().getTime() ); 
				
refresh_threshold = Number(runtime_start + min_error_refresh_time);
				
console.log(' ');
console.log('Refresh Alert: This app will attempt to fix the detected issue with an');
console.log('app restart (no more than every ' + (min_error_refresh_time / 60000) + ' minutes, until the error clears up).');
console.log(' ');
				
				
	// Reload, if we are within the minimum reload time window, AND the kucoin auth cache has been refreshed since app load time
	if ( error_detected_timestamp >= refresh_threshold && typeof kucoin_update_time !== 'undefined' ) {
	    
	kucoin_refreshed_by = kucoin_update_time + 3660000; // 61 minutes after last kucoin auth cache refresh (in milliseconds)
	    
	    if ( kucoin_refreshed_by < error_detected_timestamp ) {

            // Wait one additional minute before reload, in case any bash script updating the cache has time to finish
            setTimeout(function() {
            location.reload(true);
            }, 60000);  // 60000 milliseconds = 1 minute
	    
	    }
	
	}


}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function market_id_parser(market_id, exchange) {
    
    
    if ( exchange == 'coingecko' ) {
    market_id = market_id.split(":").pop();
    }

	
market_id = market_id.toUpperCase(); // Uppercase

// So we only have to search for a hyphen, #CONVERT ALL API MARKET PAIRING DELIMITERS TO HYPHENS HERE#
market_id = market_id.replace(":", "-"); 
market_id = market_id.replace("/", "-"); 
market_id = market_id.replace("_", "-"); 


	// NON-delimited market IDs
	if ( market_id.indexOf("-") == -1 ) {
	pairing = regex_pairing_detection(market_id);
	asset = market_id.replace(pairing, "");
	}
	// HYPHEN-delimited market IDs 
	// (ALL DELIMITERS ARE CONVERTED TO HYPHENS [IN THIS FUNCTION ONLY]...SEE market_id AT FUNCTION TOP)
	else {
	pairing = market_id.replace(/\b([A-Za-z]*)-/g, "");
	asset = market_id.replace(/-[A-Za-z0-9]*/g, "");
	}


parsed_markets[market_id] = { "pairing" : pairing, "asset" : asset };

return parsed_markets[market_id];

}


/////////////////////////////////////////////////////////////


function upgrade_check() {
    
    
    // Upgrade checks
    if ( upgrade_notice == 'on' ) {
        
        
    	$.get( "https://api.github.com/repos/taoteh1221/Slideshow_Crypto_Ticker/releases/latest", function(data) {
    	    
    	var latest_version = data.tag_name;
    	
    	
    	    if ( app_version != latest_version ) {
    	
        	var latest_version_description = data.body;
        	
        	var latest_version_download = data.zipball_url;
        	
        	var latest_version_installer = "wget --no-cache -O TICKER-INSTALL.bash https://git.io/Jqzjk;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash";
        	
        	// Remove anything AFTER formatting in brackets in the description (including the brackets)
        	// (removes the auto-added sourceforge download link)
        	latest_version_description = latest_version_description.split('[')[0]; 
        	
        	latest_version_description = "Upgrade Description:\n\n" + latest_version_description.trim();
        	
        	latest_version_description = latest_version_description
        	+ "\n\nAutomatic install terminal command:\n\n" + latest_version_installer + "\n\n";
        	
        	window.latest_version_description = latest_version_description
        	+ "Manual Install File:\n\n" + latest_version_download
        	+ "\n\nChangelog:\n\nhttps://raw.githubusercontent.com/taoteh1221/Slideshow_Crypto_Ticker/main/DOCUMENTATION-ETC/changelog.txt"
        	+ "\n\n(select all the text of either install method to auto-copy to clipboard)";
    	        
            $("#upgrade_alert").css({ "display": "block" });
            
            $("#upgrade_alert").html("<img id='upgrade_icon' src='images/upload-cloud-fill.svg' alt='' title='' /><span class='more_info' title=''>Upgrade available: v" + latest_version + "<br />(running v" + app_version + ")</span>").css("color", "#FFFF00"); 
            
    	    }
    	    else {
    	    var latest_version_description;
    	    var latest_version_download;
    	    var latest_version_installer;
    	    window.latest_version_description = '';
            $("#upgrade_alert").css({ "display": "none" });
            $("#upgrade_alert").html("").css("color", "#FFFF00"); 
    	    }
    	    
    	   
    	});


        // Rerun upgrade_check() again after upgrade_api_refresh_milliseconds
        setTimeout(function() {
        upgrade_check();
        }, upgrade_api_refresh_milliseconds);  
    	
	
	}
	

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function rest_connect(exchange) {

		
   if ( debug_mode == 'on' ) {
   console.log('rest_connect'); // DEBUGGING
   }
    
   
   // Get REST API endpoint data
   $.get(api[exchange], function(data) {
   
   
	   if ( debug_mode == 'on' ) {
       console.log(exchange + ' API endpoint: ' + api[exchange]);
       console.log('Loading / reloading REST API for: ' + exchange);
	   console.log(data);
	   }
		
       
       // Coingecko
       if ( exchange == 'coingecko' )	{
    	    
    	    
           Object.keys(rest_ids[exchange]).forEach(function(api_id) {
               
               
               Object.keys(rest_ids[exchange][api_id]).forEach(function(market_id) {
               
               market_id = rest_ids[exchange][api_id][market_id];
              
              
            	   // Render (IF market_id is defined)
            		if ( typeof market_id !== 'undefined' ) {
            		
            		update_key = js_safe_key(api_id + market_id, exchange);
                    
            		
            			// To assure appropriate ticker updated
            			if ( typeof update_key !== 'undefined' ) {
                           
            			
            			parsed_market_id = market_id_parser(market_id, exchange);
            					 
            			asset = parsed_market_id.asset;
            			
            			pairing = parsed_market_id.pairing;
            			
            			
            			  if ( typeof data[api_id] !== 'undefined' ) {
                		  price_raw = data[api_id][pairing.toLowerCase()];
                		  volume_raw = data[api_id][pairing.toLowerCase() + '_24h_vol'];
            			  }
            			  else if ( typeof data !== 'undefined' ) {
                		  price_raw = false;
                		  volume_raw = false;
            			  }
            			  else {
                		  price_raw = 0;
                		  volume_raw = 0;
            			  }
        				 
                				 
                        base_volume = pair_volume('pairing', price_raw, volume_raw);
                		   
            		    update_ticker(update_key, market_id, asset, pairing, price_raw, base_volume, exchange);
            				
            			}
            			
            		
            		}
            	   
                    	
                });
        	   
                	
            });
    	
    	
       } // END coingecko


   }) // END .get
   
   
   // If .get endpoint fails
   .fail(function() {
   $(".status_wrapper_" + exchange).css({ "display": "inline" });
   $(".status_" + exchange).text("Error").css("color", "#fc4e4e", "important");
   });


   // Rerun rest_connect() again after rest_api_refresh_milliseconds
   setTimeout(function() {
   rest_connect(exchange);
   }, rest_api_refresh_milliseconds);  
            
            
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function market_config() {

console.log('market_config'); // DEBUGGING
//console.log('is_online = ' + is_online); // DEBUGGING

kucoin_config(); // Check / load kucoin data BEFORE MARKET CONFIG

    
    if ( is_online == false ) {
    return 'offline';
    }
    

// Exchange API endpoints

// WE DYNAMICALLY ADD THE KUCOIN ENDPOINT within render_interface()

api['binance'] = 'wss://stream.binance.com:9443/ws';

api['coinbase'] = 'wss://ws-feed.pro.coinbase.com';

api['kraken'] = 'wss://ws.kraken.com';

api['hitbtc'] = 'wss://api.hitbtc.com/api/2/ws';

api['bitstamp'] = 'wss://ws.bitstamp.net/';

api['bitfinex'] = 'wss://api.bitfinex.com/ws/1';

api['okex'] = 'wss://ws.okex.com:8443/ws/v5/public';

api['gateio'] = 'wss://ws.gate.io/v3/';


// Allows alphanumeric and symbols: / - _ | :
alph_symb_regex = /^[a-z0-9\/\-_|:]+$/i;

	// Put configged markets into a multi-dimensional array, calculate number of markets total
	Object.keys(exchange_markets).forEach(function(exchange) {
		
		// If markets exist for this exchange in config.js, and haven't been added yet to the 'markets' (ALL exchange markets) array yet
    	if ( typeof exchange_markets[exchange] == 'undefined' || exchange_markets[exchange].trim() == '' ) {
    	console.log(exchange + ' markets not defined, skipping...');
    	}
    	else if ( !exchange_markets[exchange].match(alph_symb_regex) ) {
    	console.log(exchange + ' markets not properly setup (CHECK FOR BAD FORMATTING), skipping...');
    	}
		else if ( exchange_markets[exchange].trim() != '' && typeof markets[exchange] == 'undefined' ) {
		markets[exchange] = exchange_markets[exchange].split("|");
		markets_length = markets_length + markets[exchange].length;
		}
			
	});


//console.log(markets); // DEBUGGING


	// Websocket subscribe arrays
	Object.keys(markets).forEach(function(exchange) {
		    
	rest_ids[exchange] = [];
		    
	rest_other[exchange] = [];
		
		
		// REST API configs
	
		// Coingecko
		if ( exchange == 'coingecko' ) {
		
		    
        	Object.keys(markets[exchange]).forEach(function(market) {
            
            //console.log(markets[exchange][market]);
            
            temp = markets[exchange][market].split(":");
            
        	
        	   if ( typeof rest_ids[exchange][temp[0]] === 'undefined' ) {
        	   rest_ids[exchange][temp[0]] = [];
        	   }
        	
            
               // Create data array for ticker
               if ( rest_ids[exchange][temp[0]].includes(temp[1]) != true ) {
               rest_ids[exchange][temp[0]].push(temp[1]);
               }
        	
        			
        	});
	        
	        
	        ids = '';
	        currencies = '';
	        // Render endpoint URL
	        Object.keys(rest_ids[exchange]).forEach(function(api_id) {
	        
        	
        	   if ( ids == '' ) {
        	   ids = api_id;
        	   }
        	   else {
        	   ids = ids + ',' + api_id;
        	   }
        	
        	
        	   Object.keys(rest_ids[exchange][api_id]).forEach(function(market) {
               
               temp2 = rest_ids[exchange][api_id][market].split("/");
        	
            
                   // Create data array for API endpoint
                   if ( rest_other[exchange].includes(temp2[1]) != true ) {
        	               	       
                	   if ( currencies == '' ) {
                	   currencies = temp2[1];
                	   }
                	   else {
                	   currencies = currencies + ',' + temp2[1];
                	   }
            	   
            	   rest_other[exchange].push(temp2[1]);
            	   
                   }
                   
	        
        	   });
	        
	        
        	});


        api[exchange] = 'https://api.coingecko.com/api/v3/simple/price?ids=' + ids + '&vs_currencies=' + currencies + '&include_24hr_vol=true';
		
		
		} // END Coingecko
		
	    
        // Skip invalid exchange configs (RUN #AFTER# REST API CONFIGS / #BEFORE# WEBSOCKET API CONFIGS)
        if ( valid_endpoint(exchange) == false ) {
        return;
        }
		
		
		// WEBSOCKET API configs
		
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
		// Kraken
		else if ( exchange == 'kraken' ) {
			
    		// API call config
    		subscribe_msg[exchange] = {
    			"event": "subscribe",
    			"pair": [],
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
		// Bitfinex
		else if ( exchange == 'bitfinex' ) {
			
    		// API call config
    		subscribe_msg[exchange] = {
    			"event": "subscribe",
    			"channel": "ticker",
    			"pair": ""
    		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange]['pair'] = element; 
			loop = loop + 1;
			});
		
		}
		// OKex
		else if ( exchange == 'okex' ) {
			
    		// API call config
    		subscribe_msg[exchange] = {
              "op": "subscribe",
              "args": []
    		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			     subscribe_msg[exchange].args[loop] =     {
                  "channel": "index-tickers",
                  "instId": element
                 };
			loop = loop + 1;
			});
		 
		 
		
		}
		// Gate.io
		else if ( exchange == 'gateio' ) {
			
    		// API call config
    		subscribe_msg[exchange] = {
    		"id": 12312,
    		"method": "ticker.subscribe",
    		"params": []
    		};
		 
		 
			// Add markets to API call
			var loop = 0;
			markets[exchange].forEach(element => {
			subscribe_msg[exchange].params[loop] = element; 
			loop = loop + 1;
			});
		
		}
		
		
		if ( debug_mode == 'on' ) {
	    console.log(subscribe_msg[exchange]);
		}
        
	
	});



}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function websocket_connect(exchange) {

		
	if ( debug_mode == 'on' ) {
    console.log('websocket_connect'); // DEBUGGING
    }
	
	
	// Create new socket
	sockets[exchange] = new WebSocket(api[exchange]);
    
    
        // Fopr EXCHANGE_NAME_HERE, hange binary type from "blob" to "arraybuffer"
        if ( exchange == 'EXCHANGE_NAME_HERE' ) {
        sockets[exchange].binaryType = "arraybuffer";
        }
   
   
	// Open socket ///////////////////////////////////////////////////
	sockets[exchange].onopen = function() {
	sockets[exchange].send(JSON.stringify(subscribe_msg[exchange]));
	};
   
   
	// Socket response ///////////////////////////////////////////////////
	sockets[exchange].onmessage = function(e) {
	    
	   
	   // Check if response is JSON format or compressed websocket data, otherwise presume just a regular string
	   if ( is_json(e.data) == true ) {
	   msg = JSON.parse(e.data);
	   }
	   else if ( exchange == 'EXCHANGE_NAME_HERE' ) {
       
       // NOTES ON DECOMPRESSING (ALSO NEEDED sockets[exchange].binaryType = "arraybuffer"; before opening websocket)
       
	   // https://nodeca.github.io/pako/
	   // https://stackoverflow.com/questions/4507316/zlib-decompression-client-side
	   // https://stackoverflow.com/questions/57264517/pako-js-error-invalid-stored-block-lengths-when-trying-to-inflate-websocket-m
	   
	   // THESE IDIOTS CHANGED SOMETHING AT THE END OF 2/2022 IN THEIR API...FIGURE OUT WTF IT IS SOMEDAY, OR JUST REMOVE SUPPORT FOR THIS EXCHAGE!
       
          try {
              
              // Decompress the data, convert to string
              msg = JSON.parse(pako.inflateRaw(e.data, {
              to: 'string'
              }));
              
          }
          catch (err) {
          console.log(err);
          }
  
	   }
	   else {
	   msg = e.data;
	   }
		
		
	   if ( debug_mode == 'on' ) {
	   console.log(typeof msg); // DEBUGGING
	   console.log(msg); // DEBUGGING
	   }
	   
	   
		// Parse exchange data
		
		// Coinbase
		if ( exchange == 'coinbase' && msg["type"] == 'ticker' ) {
				 
		market_id = msg["product_id"];
				 
		price_raw = msg["price"];
				 
		volume_raw = msg["volume_24h"];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// Binance
		else if ( exchange == 'binance' && !msg["id"] && msg["e"] == '24hrTicker' ) {
				 
		market_id = msg["s"];
				 
		price_raw = msg["c"];
				 
		volume_raw = msg["q"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		// Kraken
		else if ( exchange == 'kraken' && !msg["event"] && msg[2] == 'ticker' ) {
				 
		market_id = msg[3];
				 
		price_raw = msg[1]["c"][0];
				 
		volume_raw = msg[1]["v"][1];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// HitBTC
		else if ( exchange == 'hitbtc' && !msg["result"] && msg["method"] == 'ticker' ) {
				 
		market_id = msg["params"]["symbol"];
				 
		price_raw = msg["params"]["last"];
				 
		volume_raw = msg["params"]["volumeQuote"];
		   
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
		// Kucoin
		else if ( exchange == 'kucoin' ) {
				 
			// If we have trade data available
			if ( msg["subject"] == 'trade.snapshot' ) {
					 
			market_id = msg["data"]["data"]["symbol"];
					 
			price_raw = msg["data"]["data"]["close"];
					 
			volume_raw = msg["data"]["data"]["volValue"];
			   
			base_volume = pair_volume('pairing', price_raw, volume_raw);
					 
			}
			// If we recieve an error reqponse
			else if ( msg["type"] == 'error' ) {
			console.log('Kucoin API Error: ' + msg["data"]);
			kucoin_reload();
			}
				 
		}
		// Bitstamp
		else if ( exchange == 'bitstamp' && msg["event"] == 'trade' ) {
				 
		market_id = msg["channel"].replace("live_trades_", "");
				 
		price_raw = msg["data"]["price"];
		
		// RE-SET volume_raw / base_volume AS UNDEFINED, as bitstamp provides no 24hr volume data
		
		var volume_raw;
		
		var base_volume;
				 
		}
		// Bitfinex
		else if ( exchange == 'bitfinex' && msg.length == 11 ) {
				 
		market_id = subscribe_msg[exchange]['pair'];
				 
		price_raw = msg[7];
				 
		volume_raw = msg[8];
		   
		base_volume = pair_volume('asset', price_raw, volume_raw);
				 
		}
		// OKex
		else if ( exchange == 'okex' && msg['data'] ) {
				 
		market_id = msg['data'][0]['instId'];
				 
		price_raw = msg['data'][0]['idxPx'];
		
		// RE-SET volume_raw / base_volume AS UNDEFINED, as okex provides no 24hr volume data
		
		var volume_raw;
		
		var base_volume;
				 
		}
		// Gateio
		else if ( exchange == 'gateio' && msg['method'] == 'ticker.update' ) {
				 
		market_id = msg['params'][0];
				 
		price_raw = msg['params'][1]['last'];
		
		volume_raw = msg['params'][1]['baseVolume'];
		
		base_volume = pair_volume('pairing', price_raw, volume_raw);
				 
		}
	  
	    
	    // Nullify rendering under these circumstances (msg is not our data set)
	    if ( 
	    exchange == 'bitfinex' && msg[1] == 'hb' // Bitfinex
	    ) {
	    var market_id; // Set as UNDEFINED
	    }
	    
  
	   // Render (IF market_id is defined)
		if ( typeof market_id !== 'undefined' ) {
		
		update_key = js_safe_key(market_id, exchange);
		
			// To assure appropriate ticker updated
			if ( typeof update_key !== 'undefined' ) {
	
	           // Using ".status_" + update_key INSTEAD, TO SHOW PER-ASSET 
               if ( show_exchange_name == 'off' ) { 
               $(".parenth_" + update_key).css({ "display": "none" });
               }
               else {
               $(".parenth_" + update_key).css({ "display": "inline" });
               $(".status_" + update_key).text( render_names(exchange) ).css("color", "#2bbf7b", "important");
               }
       
        			
        	parsed_market_id = market_id_parser(market_id, exchange);
        					 
        	asset = parsed_market_id.asset;
        			
        	pairing = parsed_market_id.pairing;
        			
			update_ticker(update_key, market_id, asset, pairing, price_raw, base_volume);
			
			}
			
		}
	   
	   
	};
   
   
	
	// When socket closes, reconnect ///////////////////////////////////////////////////
	sockets[exchange].onclose = function(e) {
		
	//console.log('Connecting', e.reason);
	   
	   setTimeout(function() {
		    
	   $(".status_wrapper_" + exchange).css({ "display": "inline" });
	    
	   $(".status_" + exchange).text("Reloading").css("color", "#FFFF00", "important");
	   
	   websocket_connect(exchange);
	       
		
	   }, 60000); // Reconnect after no data received for 1 minute
	   
	};
   
   
   
	// Socket error ///////////////////////////////////////////////////
	sockets[exchange].onerror = function(err) {
	
	$(".status_wrapper_" + exchange).css({ "display": "inline" });
	    
	$(".status_" + exchange).text("Error").css("color", "#fc4e4e", "important");
	
	console.log('Socket encountered error: ', err.message, 'Closing socket');
	
	sockets[exchange].close();
	
	    if ( exchange == 'kucoin' ) {
	    kucoin_reload();
	    }
	
	};
	
  
}


/////////////////////////////////////////////////////////////////////////////////////////////////////


