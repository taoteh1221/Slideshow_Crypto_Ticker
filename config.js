
// Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

var exchange_markets = []; // LEAVE ALONE, AND DON'T DELETE (REQUIRED!!)


///////////////////////////////////////////
// START config
///////////////////////////////////////////

//  TYPOS LIKE MISSED SEMICOLONS / MISSED QUOTES / ETC WILL BREAK THE APP, BE CAREFUL EDITING THIS CONFIG FILE!


// ############## PER-EXCHANGE FORMATTING EXAMPLES ##########################
////
// Which crypto asset(s) to display on the ticker
// Separate with pipe | symbol to "slideshow" between multiple tickers on the same exchange
////
// Bitstamp formatting example  (MULTIPLE TICKERS NOT SUPPORTED): 'btcgbp'

// Bitfinex formatting example  (MULTIPLE TICKERS NOT SUPPORTED): 'BTCEUR', OR 'PLANETS:UST' FOR OVER 4 CHARACTER SYMBOLS

// Coinbase formatting example: 'BTC-USD|BTC-GBP|ETH-USD|ETH-BTC|ETH-EUR|MKR-USD|MKR-BTC|MANA-USDC'

// Binance formatting example:  'btcusdt|ethusdt|ethbtc|mkrusdt'

// CoinGecko formatting example: 'bitcoin:btc/usd|bitcoin:btc/eur|bitcoin:btc/chf|grape-2:grape/usd|raydium:ray/btc'

// Kucoin formatting example:   'MANA-USDT|ENJ-BTC'

// Kraken formatting example:   'XBT/USD|XBT/CAD|XBT/EUR|ETH/USD|ETH/EUR|ETH/CAD'

// Okex formatting example:     'ENJ-USDT|ENJ-BTC'

// Hitbtc formatting example    (MULTIPLE TICKERS NOT SUPPORTED): 'ETHBTC'

// Gate.io formatting example:  'MANA_USDT|SAMO_USDT'
////
//// 
// Bitstamp markets (set to '' to disable)
// !!BITSTAMP WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
exchange_markets['bitstamp'] = ''; 
////
////
// Bitfinex markets (set to '' to disable) 
// !!BITFINEX WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
exchange_markets['bitfinex'] = '';  
////
////
// Coinbase markets (set to '' to disable)
exchange_markets['coinbase'] = 'BTC-USD|ETH-USD|ETH-BTC|SOL-USD'; 
////
//// 
// Coingecko markets (set to '' to disable)
// USE COINGECKO'S API ID FOR EACH ASSET! (SEE COINGECKO ASSET PAGE'S INFO SECTION) 
// PAIRING ASSET MUST BE SUPPORTED BY COINGECKO'S 'vs_currencies' API PARAMETER!
// FORMAT IS 'api-id-here:symbol/pairing'
exchange_markets['coingecko'] = 'solana:sol/btc|grape-2:grape/usd';
////
////
// Binance markets (set to '' to disable)
exchange_markets['binance'] = 'hntusdt|hntbtc'; 
////
////
// Kucoin markets (set to '' to disable)
// !!KUCOIN REQUIRES USING THE INSTALL SCRIPT!!
exchange_markets['kucoin'] = 'MANA-USDT'; 
////
////
// Kraken markets (set to '' to disable)
exchange_markets['kraken'] = ''; 
////
////
// OKex markets (set to '' to disable) 
exchange_markets['okex'] = '';
////
////
// HitBTC markets (set to '' to disable) 
// !!HITBTC WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
exchange_markets['hitbtc'] = ''; 
////
////
// Gateio markets (set to '' to disable) 
exchange_markets['gateio'] = 'SLC_USDT|RNDR_USDT|SLRS_USDT|BIT_USDT|SAMO_USDT';


// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// I M P O R T A N T   S E T U P   I N F O R M A T I O N !!!!!!!!!!!!!!!!!!!!
// Run COMMAND "~/ticker-restart" (WITHOUT QUOTES) TO SHOW UPDATED SETUP!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


// Screen orientation (offset in degrees)
var orient_screen = 0; // Normal (upright) = 0, Flipped (upside down) = 180, Sideways (left or right) = 90 or 270


// Vertical position (adjusts the ticker's vertical position up/down)
// CAN BE NEGATIVE, TO GO THE OPPOSITE WAY
var vertical_position = 75; // Default = 38 (SMALL SCREEN), 75 (MEDIUM SCREEN), 150 (LARGE SCREEN)


// Horizontal position (adjusts the ticker's horizontal position left/right)
// CAN BE NEGATIVE, TO GO THE OPPOSITE WAY
var horizontal_position = 0; // Default = 10 (SMALL SCREEN), 0 (MEDIUM/LARGE SCREEN)


// Show exchange name in title (next to asset ticker symbol)
var show_exchange_name = 'on'; // 'on' / 'off', Default = 'on'


// Show volume section EVEN IF NO VOLUME WAS PROVIDED
var show_empty_volume = 'on'; // 'off' / 'on', Default = 'on'


// Show system temperature / memory stats (TOP LEFT corner of app screen, if device temps / RAM useage are available)
var show_system_data = 'on'; // 'on' / 'off', Default = 'on'
////
// System data font size
var system_data_size = 3.00; // Default = 3.00 (#CAN# BE DECIMALS HERE, AS WERE USING THE CSS vw STANDARD)


// Title font size
var title_size = 115; // Default = 57 (SMALL SCREEN), 115 (MEDIUM SCREEN), 230 (LARGE SCREEN)


// 24 hour volume font size
var volume_size = 84; // Default = 42 (SMALL SCREEN), 84 (MEDIUM SCREEN), 168 (LARGE SCREEN)


// Ticker font size
var ticker_size = 145; // Default = 73 (SMALL SCREEN), 145 (MEDIUM SCREEN), 290 (LARGE SCREEN)


// Ticker arrow size RATIO (to ticker size), DECIMAL NUMBER FORMAT X.XX OF 1.00 OR LESS
// THIS #ALREADY AUTO-RESIZES# BASED ON THE TICKER SIZE, SO YOU USUALLY CAN LEAVE THIS
// #AS-IS#, UNLESS YOU WANT THE RATIO TO TICKER SIZE DIFFERENT!
var arrow_size = 0.65; // Default = 0.65 (same height as ticker price text)
////
// Spacing between ticker arrow, and ticker price text
var arrow_spacing = 20; // Default = 10 (SMALL SCREEN), 20 (MEDIUM SCREEN), 40 (LARGE SCREEN)


// Maximum decimal places for ticker values worth under 1.00 in unit value, for prettier / less-cluttered interface
var ticker_max_decimals = 6; // Default = 6


// Minimum decimal places for ANY ticker values,
// EXCEPT FOR FIAT UNIT VALUES UNDER 100 (which are forced to 2 decimals minimum, UNLESS THIS VALUE IS 2 OR HIGHER)
// 0 disables
var ticker_min_decimals = 0; // Default = 0


// PRICE PERCENTAGE to round off ticker price IN DECIMALS (DYNAMIC / RELATIVE to price amount)
// (FINE-GRAINED CONTROL OVER TICKER PRICE ROUNDING #AMOUNT OF DECIMALS SHOWN#)
// (interface examples: one = 1000, tenth = 1000, hundredth = 1000.9, thousandth = 1000.09)
// (interface examples: one = 100, tenth = 100.9, hundredth = 100.09, thousandth = 100.009)
// (interface examples: one = 10.9, tenth = 10.09, hundredth = 10.009, thousandth = 10.0009)
// #FIAT# CURRENCY VALUES UNDER 100 #ARE FORCED TO 2 DECIMALS MINUMUM#, UNLESS USING 'thousandth'
// #ALWAYS# OVERIDDEN BY ticker_min_decimals!
var ticker_round_percent = 'tenth'; // (OF A PERCENT) 'one', 'tenth', 'hundredth', 'thousandth'
////
// FORCE a fixed amount of decimals on ticker price, CALCULATED OFF ABOVE ticker_round_percent SETTING
// (ALWAYS SAME AMOUNT OF DECIMALS, #EVEN IF IT INCLUDES TRAILING ZEROS#) 
// #ALWAYS# OVERIDDEN BY ticker_min_decimals!
var ticker_round_fixed_decimals = 'on'; // 'off', 'on'


// EMULATED / dynamic monospace font WIDTH spacing (percent of EACH font size as a decimal) 
// (ALL font widths for ticker/volume numbers are emulated as monospace, so numbers don't "jump around" when changing in real-time)
// DECIMAL NUMBER FORMAT X.XX OF 1.00 OR LESS, OR null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)
var monospace_width = 0.65; // Default = 0.65


// ALL font weights (for ALL ticker text)
var font_weight = 'normal'; // Default = 'normal', can be any proper CSS font weight value


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


// MINUTES before refreshing non-websocket trading exchange API endpoints (coingecko)
// #DON'T ADJUST TOO LOW#, OR NON-WEBSOCKET APIs LIKE COINGECKO MAY DROP YOUR CONNECTION!
var rest_api_refresh = 5; // Default = 5


// SECONDS between "slideshowing" multiple tickers (if multiple assets configured)
// SET TO 0 FOR AUTO MODE (trys to show all tickers in 1 minute, BUT has a 5 second per-ticker MINIMUM)
var slideshow_speed = 9; // Default = 9


// Slideshow transition speed (fade out / fade in) IN SECONDS (can be decimals)
var transition_speed = 0.70; // Default = 0.70


// SECONDS to wait before reloading app after internet outages
// #DON'T ADJUST TOO LOW#, OR DEVICE'S INTERNET MAY NOT BE #FULLY / STABALY# BACK ONLINE YET!
var app_reload_wait = 60; // Default = 60


// Minimum number of MINUTES to wait before auto-reloading the app IF ERRORS ARE DETECTED THAT MAY BE FIXED WITH A RELOAD
// (#NOT# USED FOR DROPPED API CONNECTIONS, SINCE WE AUTO-RECONNECT WITHOUT RELOADING EVERYTHING, but this is very helpful
// if the kucoin API token expires / any other javascript app cache variables need to be reloaded with new values)
var auto_error_fix_min = 5; // Default = 5


// HOURS before re-checking for any newly-released upgrades (at github)
// #KEEP LOW#, AS THIS APP MAY RELOAD ITSELF DAILY IF IT DETECTS API / INTERNET ISSUES,
// IN WHICH CASE #THE CHECK INTERVAL START TIME IS RESET#
var upgrade_api_refresh = 1; // Default = 1
////
// Enable / disable upgrade check / notice (TOP RIGHT corner of app screen, when an newer version is available for download)
// (Checks latest release version via github.com API endpoint value "tag_name" 
// @ https://api.github.com/repos/taoteh1221/Slideshow_Crypto_Ticker/releases/latest)
var upgrade_notice = 'on'; // 'on' / 'off', Default = 'on'


// DEBUG MODE (turns on console logging for certain logic)
var debug_mode = 'off'; // 'on' / 'off', Default = 'off'



// All #ACTIVATED# market pairings (what the asset is paired with in markets), AND their currency symbols
// ADD ANY NEW SUPPORTED (CHECK WITH THE EXCHANGE) MARKET PAIRINGS HERE YOU WANT #ACTIVATED# IN THIS APP



// Crypto market pairings (KEYS #MUST BE# UPPERCASE)
var crypto_pairings = {
				        'BNB': 'Ⓑ ',
						'BTC': 'Ƀ ',
						'ETH': 'Ξ ',
						'KCS': 'Ḵ ',
						'XBT': 'Ƀ ',
					   };
								
								

// Fiat-equivelent market pairings (KEYS #MUST BE# UPPERCASE)
var fiat_pairings = {
						'AED': 'د.إ',
						'ARS': 'ARS$',
						'AUD': 'A$',
						'BAM': 'KM ',
						'BDT': '৳',
						'BOB': 'Bs ',
						'BRL': 'R$',
						'BWP': 'P ',
						'BYN': 'Br ',
						'CAD': 'C$',
						'CHF': 'CHf ',
						'CLP': 'CLP$',
						'CNY': 'C¥',
						'COP': 'Col$',
						'CRC': '₡',
						'CZK': 'Kč ',
						'DAI': '◈ ',
						'DKK': 'Kr. ',
						'DOP': 'RD$',
						'EGP': 'ج.م',
						'EUR': '€',
						'GBP': '£',
						'GEL': 'ლ',
						'GHS': 'GH₵',
						'GTQ': 'Q ',
						'HKD': 'HK$',
						'HUF': 'Ft ',
						'IDR': 'Rp ',
						'ILS': '₪',
						'INR': '₹',
						'IRR': '﷼',
						'JMD': 'JA$',
						'JOD': 'د.ا',
						'JPY': 'J¥',
						'KES': 'Ksh ',
						'KRW': '₩',
						'KWD': 'د.ك',
						'KZT': '₸',
						'LKR': 'රු, ரூ',
						'MAD': 'د.م.',
						'MUR': '₨ ',
						'MWK': 'MK ',
						'MXN': 'Mex$',
						'MYR': 'RM ',
						'NGN': '₦',
						'NIS': '₪',
						'NOK': 'kr ',
						'NZD': 'NZ$',
						'PAB': 'B/. ',
						'PEN': 'S/ ',
						'PHP': '₱',
						'PKR': '₨ ',
						'PLN': 'zł ',
						'PYG': '₲',
						'QAR': 'ر.ق',
						'RON': 'lei ',
						'RSD': 'din ',
						'RUB': '₽',
						'RQF': 'R₣ ',
						'SAR': '﷼',
						'SEK': 'kr ',
						'SGD': 'S$',
						'THB': '฿',
						'TRY': '₺',
						'TUSD': 'Ⓢ ',
						'TWD': 'NT$',
						'TZS': 'TSh ',
						'UAH': '₴',
						'UGX': 'USh ',
						'USD': '$',
						'USDC': 'Ⓢ ',
						'USDT': '₮ ',
						'UST': 'Ⓢ ',
						'UYU': '$U ',
						'VND': '₫',
						'VES': 'Bs ',
						'XAF': 'FCFA ',
						'XOF': 'CFA ',
						'ZAR': 'R ',
						'ZMW': 'ZK ',
					};



///////////////////////////////////////////
// END config
///////////////////////////////////////////



