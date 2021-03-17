
// Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

var exchange_markets = []; // LEAVE ALONE / DON'T DELETE (REQUIRED INIT)


//  TYPOS LIKE MISSED SEMICOLONS / MISSED QUOTES / ETC WILL BREAK THE APP, BE CAREFUL EDITING THIS CONFIG FILE


// ############## PER-EXCHANGE FORMATTING EXAMPLES ##########################
// Which crypto asset(s) to display on the ticker
// Separate with pipe | symbol to "slideshow" between multiple tickers on the same exchange
// Kraken example: 'XBT/USD|XBT/CAD|XBT/EUR|ETH/USD|ETH/EUR|ETH/CAD'
// Coinbase example: 'BTC-USD|BTC-GBP|ETH-USD|ETH-BTC|ETH-EUR|MKR-USD|MKR-BTC|MANA-USDC'
// Binance example: 'btcusdt|ethusdt|ethbtc|mkrusdt'
// Kucoin example: 'MANA-BTC|ENJ-BTC|SXP-USDT'
// Hitbtc example (MULTIPLE TICKERS NOT SUPPORTED): 'MYSTBTC'
// Bitstamp pairs (MULTIPLE TICKERS NOT SUPPORTED): btcusd, btceur, btcgbp, btcpax, btcusdc, gbpusd, gbpeur, eurusd, xrpusd, xrpeur, xrpbtc, xrpgbp, xrppax, ltcusd, ltceur, ltcbtc, ltcgbp, ethusd, etheur, ethbtc, ethgbp, ethpax, ethusdc, bchusd, bcheur, bchbtc, bchgbp, paxusd, paxeur, paxgbp, xlmbtc, xlmusd, xlmeur, xlmgbp, linkusd, linkeur, linkgbp, linkbtc, linketh, omgusd, omgeur, omggbp, omgbtc, usdcusd, usdceur, daiusd, kncusd, knceur, kncbtc, mkrusd, mkreur, mkrbtc, zrxusd, zrxeur, zrxbtc, gusdusd
////
////
// Bitstamp markets (set to '' to disable)
exchange_markets['bitstamp'] = 'btceur';// !!BITSTAMP WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
////
////
// Coinbase markets (set to '' to disable)
exchange_markets['coinbase'] = 'BTC-USD|ETH-USD|ETH-BTC|LRC-USD|LRC-BTC'; 
////
////
// Binance markets (set to '' to disable)
exchange_markets['binance'] = 'uniusdt|unibtc|mkrusdt|mkrbtc'; 
////
////
// Kraken markets (set to '' to disable)
exchange_markets['kraken'] = 'KEEP/USD|MANA/USD'; 
////
////
// Kucoin markets (set to '' to disable)
exchange_markets['kucoin'] = 'MANA-BTC|ENJ-BTC|SXP-USDT';
////
////
// HitBTC markets (set to '' to disable) 
exchange_markets['hitbtc'] = 'MYSTBTC'; // !!HITBTC WEBSOCKET API ONLY SUPPORTS ONE ASSET!!



// Maximum decimal places for coins worth under 1.00 unit value [btc/eth/usd/usdc/gbp/eur/whatever], for prettier / less-cluttered interface
var max_price_decimals = 7;



// Seconds between "slideshowing" multiple tickers (if multiple assets configured)
// SET TO ZERO FOR AUTO MODE (trys to show all tickers in 1 minute, BUT has a 5 second per-ticker MINIMUM)
var slideshow_speed = 0; 



// Title font size
var title_size = 54;



// Ticker font size
var ticker_size = 63;



// Ticker arrow size (percent of TICKER font HEIGHT as a decimal)
var arrow_size = 0.65; // decimal number format X.XX of 1.00 or less



// Volume font size
var volume_size = 34;



// Vertical position (adjusts the ticker's vertical position up/down)
var vertical_position = 38;



// Hide volume section, IF NO VOLUME WAS PROVIDED
var hide_empty_volume = 'no'; // 'no' / 'yes'



// Screen orientation (upright, or flip upside-down)
var orient_screen = 'flip'; // 'upright' or 'flip'



// Background color (https://www.w3schools.com/colors/colors_picker.asp)
var background_color = '#000000'; // '#colorcode'



// Text color (https://www.w3schools.com/colors/colors_picker.asp)
var text_color = '#c6c6c6'; // '#colorcode'



// Use a google font...set as null for default system serif font
// Runs the ticker in ANY google font found at: https://fonts.google.com/
var google_font = 'Varela Round'; // 'fontname' IN QUOTES for ANY google font, OR null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)



// EMULATED / dynamic monospace font WIDTH spacing (percent of EACH font HEIGHT as a decimal) 
// (ALL font widths for ticker/volume numbers are emulated as monospace, 
// so numbers don't "jump around" when changing in real-time)
// Set as null to skip monospace emulation 
var monospace_width = 0.65; // decimal number format X.XX of 1.00 or less, OR null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)



// All #ACTIVATED# market pairings, AND their currency symbols
// ADD ANY NEW MARKET PAIRINGS HERE YOU WANT #ACTIVATED# IN THIS APP (IF THEY ARE NOT ADDED HERE ALREADY)


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






