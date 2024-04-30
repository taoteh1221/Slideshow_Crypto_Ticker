
// Copyright 2019-2024 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)



/////////////////////////////////////////////////////////////////////////////////////////////////////


function pair_volume(volume_type, trade_value, volume) {
	
	if ( typeof volume == 'string' ) {
	volume = parseFloat(volume);
	}

	if ( volume_type == 'asset' ) {
	base_volume = trade_value * volume; // Roughly emulate pairing volume for UX
	}
	else if ( volume_type == 'pairing' ) {
	base_volume = volume;
	}
	
return base_volume;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function trade_type(price_raw, market_id) {
	
	if ( !trade_side_price[market_id] ) {
	trade_side_arrow[market_id] = 'buy'; // If just initiated, with no change yet
	}
	else if ( price_raw < trade_side_price[market_id] ) {
	trade_side_arrow[market_id] = 'sell';
	}
	else if ( price_raw > trade_side_price[market_id] ) {
	trade_side_arrow[market_id] = 'buy';
	}
		
trade_side_price[market_id] = price_raw;

return trade_side_arrow[market_id];

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function asset_symbols(asset_abrv) {

results = new Array();

	// Unicode asset symbols
	if ( typeof fiat_pairings[asset_abrv] !== 'undefined' ) {
	results['asset_symbol'] = fiat_pairings[asset_abrv];
	results['asset_type'] = 'fiat';
	}
	else if ( typeof crypto_pairings[asset_abrv] !== 'undefined' ) {
    results['asset_symbol'] = crypto_pairings[asset_abrv];
	results['asset_type'] = 'crypto';
	}
	else {
	results['asset_symbol'] = null;
	results['asset_type'] = null;
	}


return results;

}


/////////////////////////////////////////////////////////////////////////////////////////////////////


function regex_pairing_detection(market_id) {

results = new Array();

// Merge fiat / crypto arrays TO NEW ARRAY (WITHOUT ALTERING EITHER ORIGINAL ARRAYS)
scan_pairings = $.extend({}, fiat_pairings, crypto_pairings);

// last characters of the market id
last_6 = market_id.substr(market_id.length - 6);
last_5 = market_id.substr(market_id.length - 5);
last_4 = market_id.substr(market_id.length - 4);
last_3 = market_id.substr(market_id.length - 3);


	if ( typeof scan_pairings[last_6.toUpperCase()] !== 'undefined' ) {
	return last_6.toUpperCase();
	}
	else if ( typeof scan_pairings[last_5.toUpperCase()] !== 'undefined' ) {
	return last_5.toUpperCase();
	}
	else if ( typeof scan_pairings[last_4.toUpperCase()] !== 'undefined' ) {
	return last_4.toUpperCase();
	}
	else if ( typeof scan_pairings[last_3.toUpperCase()] !== 'undefined' ) {
	return last_3.toUpperCase();
	}
	else {
	return false;
	}
	

}


/////////////////////////////////////////////////////////////////////////////////////////////////////

