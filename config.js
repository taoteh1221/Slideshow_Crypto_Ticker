
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

var exchange_markets = []; // LEAVE ALONE, AND DON'T DELETE (REQUIRED!)


//  TYPOS LIKE MISSED SEMICOLONS / MISSED QUOTES / ETC WILL BREAK THE APP, BE CAREFUL EDITING THIS CONFIG FILE!


// ############## PER-EXCHANGE FORMATTING EXAMPLES ##########################
////
// Which crypto asset(s) to display on the ticker
// Separate with pipe | symbol to "slideshow" between multiple tickers on the same exchange
////
// Bitstamp formatting example  (MULTIPLE TICKERS NOT SUPPORTED): 'btcgbp'
// Bitfinex formatting example  (MULTIPLE TICKERS NOT SUPPORTED): 'BTCEUR'
// Hitbtc formatting example    (MULTIPLE TICKERS NOT SUPPORTED): 'MYSTBTC'
// Coinbase formatting example: 'BTC-USD|BTC-GBP|ETH-USD|ETH-BTC|ETH-EUR|MKR-USD|MKR-BTC|MANA-USDC'
// Binance formatting example:  'btcusdt|ethusdt|ethbtc|mkrusdt'
// Loopring formatting example: 'LRC-USDT|LRC-ETH'
// Kraken formatting example:   'XBT/USD|XBT/CAD|XBT/EUR|ETH/USD|ETH/EUR|ETH/CAD'
// Kucoin formatting example:   'MANA-BTC|ENJ-BTC|SXP-USDT'
// Okex formatting example:     'ENJ-USDT|ENJ-BTC'
// Gate.io formatting example:  'MANA_USDT|SAMO_USDT'
// Bitmart formatting example:  'SG_USDT|SG_BTC'
////
////
// Bitstamp markets (set to '' to disable)
exchange_markets['bitstamp'] = ''; // !!BITSTAMP WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
////
////
// Bitfinex markets (set to '' to disable) 
exchange_markets['bitfinex'] = '';  // !!BITFINEX WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
////
////
// Coinbase markets (set to '' to disable)
exchange_markets['coinbase'] = 'BTC-USD|ETH-USD|SOL-USD|SOL-BTC'; 
////
////
// Binance markets (set to '' to disable)
exchange_markets['binance'] = 'hntusdt|lrcusdt'; 
////
////
// Loopring markets (set to '' to disable) 
exchange_markets['loopring'] = '';
////
////
// Kraken markets (set to '' to disable)
exchange_markets['kraken'] = 'ENJ/USD'; 
////
////
// Kucoin markets (set to '' to disable)
exchange_markets['kucoin'] = ''; // !!KUCOIN REQUIRES USING THE INSTALL SCRIPT!!
////
////
// OKex markets (set to '' to disable) 
exchange_markets['okex'] = '';
////
////
// HitBTC markets (set to '' to disable) 
exchange_markets['hitbtc'] = ''; // !!HITBTC WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
////
////
// Bitmart markets (set to '' to disable) 
exchange_markets['gateio'] = 'MANA_USDT|SAMO_USDT';
////
////
// Bitmart markets (set to '' to disable) 
exchange_markets['bitmart'] = 'SG_USDT';


// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// I M P O R T A N T   S E T U P   I N F O R M A T I O N !!!!!!!!!!!!!!!!!!!!
// Run COMMAND "~/ticker-restart" (WITHOUT QUOTES) TO SHOW UPDATED SETUP!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


// Screen orientation (offset in degrees)
var orient_screen = 180; // Normal = 0, Flipped = 180, Sideways = 90 or 270


// Vertical position (adjusts the ticker's vertical position up/down)
// CAN BE NEGATIVE, TO GO THE OPPOSITE WAY
var vertical_position = 36; // Default = 36


// Horizontal position (adjusts the ticker's horizontal position left/right)
// CAN BE NEGATIVE, TO GO THE OPPOSITE WAY
var horizontal_position = 10; // Default = 10


// Slideshow transition speed IN SECONDS (can be decimals)
var transition_speed = 0.75; // Default = 0.75


// ALL font weights (for ALL ticker text)
var font_weight = 'normal'; // Default = 'normal', can be any proper CSS font weight value


// Title font size
var title_size = 55; // Default = 55


// Ticker arrow size ratio (to ticker size), DECIMAL NUMBER FORMAT X.XX OF 1.00 OR LESS
// THIS #ALREADY AUTO-RESIZES# BASED ON THE TICKER SIZE, SO YOU USUALLY CAN LEAVE THIS
// #AS-IS#, UNLESS YOU WANT THE RATIO TO TICKER SIZE DIFFERENT!
var arrow_size = 0.65; // Default = 0.65


// Ticker font size
var ticker_size = 66; // Default = 66


// Maximum decimal places for values worth under 1.00 in unit value, for prettier / less-cluttered interface
var max_ticker_decimals = 7; // Default = 7


// 24 hour volume font size
var volume_size = 40; // Default = 40


// Hide volume section, IF NO VOLUME WAS PROVIDED
var hide_empty_volume = 'no'; // 'no' / 'yes'


// Text color (https://www.w3schools.com/colors/colors_picker.asp)
// '#colorcode'
var text_color = '#c6c6c6'; // Default = '#c6c6c6'


// Background color (https://www.w3schools.com/colors/colors_picker.asp)
// '#colorcode'
var background_color = '#000000'; // Default = '#000000'


// Use a google font...set as null for default system serif font
// Runs the ticker in ANY google font found at: https://fonts.google.com
// 'fontname' IN QUOTES for ANY google font, OR null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)
var google_font = 'Varela Round'; // Default = 'Varela Round'


// Seconds between "slideshowing" multiple tickers (if multiple assets configured)
// SET TO 0 FOR AUTO MODE (trys to show all tickers in 1 minute, BUT has a 5 second per-ticker MINIMUM)
var slideshow_speed = 5; // Default = 5


// EMULATED / dynamic monospace font WIDTH spacing (percent of EACH font size as a decimal) 
// (ALL font widths for ticker/volume numbers are emulated as monospace, so numbers don't "jump around" when changing in real-time)
// DECIMAL NUMBER FORMAT X.XX OF 1.00 OR LESS, OR null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)
var monospace_width = 0.65; // Default = 0.65


// Minimum number of minutes to wait before auto-reloading the app IF ERRORS ARE DETECTED THAT MAY BE FIXED WITH A RELOAD
// (#NOT# USED FOR DROPPED API CONNECTIONS, SINCE WE AUTO-RECONNECT WITHOUT RELOADING EVERYTHING, but this is very helpful
// if the kucoin API token expires / any other javascript app cache variables need to be reloaded with new values)
var auto_error_fix_min = 5; // Default = 5



// All #ACTIVATED# market pairings (what the asset is paired with in markets), AND their currency symbols
// ADD ANY NEW SUPPORTED (CHECK WITH THE EXCHANGE) MARKET PAIRINGS HERE YOU WANT #ACTIVATED# IN THIS APP


// Fiat-equivelent market pairings (KEYS #MUST BE# UPPERCASE)
var fiat_pairings = {
								'AUD': 'A$',
								'BRL': 'R$',
								'CAD': 'C$',
								'CHF': 'CHf',
								'EUR': '€',
								'GBP': '£',
								'HKD': 'HK$',
								'JPY': 'J¥',
								'RUB': '₽',
								'SGD': 'S$',
								'TUSD': 'Ⓢ ',
								'USD': '$',
								'USDC': 'Ⓢ ',
								'USDT': '₮ ',
								};


// Crypto market pairings (KEYS #MUST BE# UPPERCASE)
var crypto_pairings = {
								'BNB': 'Ⓑ ',
								'BTC': 'Ƀ ',
								'ETH': 'Ξ ',
								'KCS': 'Ḵ ',
								'XBT': 'Ƀ ',
								};






