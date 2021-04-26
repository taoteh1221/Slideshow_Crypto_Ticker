
// Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

var exchange_markets = []; // LEAVE ALONE, AND DON'T DELETE (REQUIRED!)


//  TYPOS LIKE MISSED SEMICOLONS / MISSED QUOTES / ETC WILL BREAK THE APP, BE CAREFUL EDITING THIS CONFIG FILE!


// ############## PER-EXCHANGE FORMATTING EXAMPLES ##########################
////
// Which crypto asset(s) to display on the ticker
// Separate with pipe | symbol to "slideshow" between multiple tickers on the same exchange
////
// Kraken formatting example: 'XBT/USD|XBT/CAD|XBT/EUR|ETH/USD|ETH/EUR|ETH/CAD'
// Coinbase formatting example: 'BTC-USD|BTC-GBP|ETH-USD|ETH-BTC|ETH-EUR|MKR-USD|MKR-BTC|MANA-USDC'
// Binance formatting example: 'btcusdt|ethusdt|ethbtc|mkrusdt'
// Kucoin formatting example: 'MANA-BTC|ENJ-BTC|SXP-USDT'
// Hitbtc formatting example (MULTIPLE TICKERS NOT SUPPORTED): 'MYSTBTC'
// Bitstamp formatting example (MULTIPLE TICKERS NOT SUPPORTED): 'btceur'
////
////
// Bitstamp markets (set to '' to disable)
exchange_markets['bitstamp'] = 'btceur'; // !!BITSTAMP WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
////
////
// Coinbase markets (set to '' to disable)
exchange_markets['coinbase'] = 'BTC-USD|ETH-USD|ETH-BTC|UNI-USD|UNI-BTC'; 
////
////
// Binance markets (set to '' to disable)
exchange_markets['binance'] = 'mkrusdt|mkrbtc|lrcusdt|lrcbtc'; 
////
////
// Kraken markets (set to '' to disable)
exchange_markets['kraken'] = 'KEEP/USD|MANA/USD'; 
////
////
// Kucoin markets (set to '' to disable)
exchange_markets['kucoin'] = 'MANA-BTC|ENJ-BTC|SXP-USDT'; // !!KUCOIN REQUIRES USING THE INSTALL SCRIPT!!
////
////
// HitBTC markets (set to '' to disable) 
exchange_markets['hitbtc'] = 'MYSTBTC'; // !!HITBTC WEBSOCKET API ONLY SUPPORTS ONE ASSET!!



// Screen orientation (upright, or flip upside-down)
var orient_screen = 'flip'; // 'upright' or 'flip'


// Vertical position (adjusts the ticker's vertical position up/down)
// CAN BE NEGATIVE, TO GO THE OPPOSITE WAY
var vertical_position = 36; // Default = 36


// Horizontal position (adjusts the ticker's horizontal position up/down)
// CAN BE NEGATIVE, TO GO THE OPPOSITE WAY
var horizontal_position = 10; // Default = 10


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
var slideshow_speed = 0; // Default = 0


// Hide volume section, IF NO VOLUME WAS PROVIDED
var hide_empty_volume = 'no'; // 'no' / 'yes'


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






