
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com

var exchange_markets = []; // LEAVE ALONE / DON'T DELETE (REQUIRED INIT)


//  TYPOS LIKE MISSED SEMICOLONS / MISSED QUOTES / ETC WILL BREAK THE APP, BE CAREFUL EDITING THIS CONFIG FILE


// Which crypto asset(s) to display on the ticker
// Separate with pipe | symbol to "slideshow" between multiple tickers
// kraken example: 'XBT/USD|XBT/CAD|XBT/EUR|ETH/USD|ETH/EUR|ETH/CAD'
// coinbase example: 'BTC-USD|BTC-GBP|ETH-USD|ETH-BTC|ETH-EUR|MKR-USD|MKR-BTC|MANA-USDC'
// binance example: 'btcusdt|ethusdt|ethbtc|mkrusdt'
// hitbtc example: 'MYSTBTC'
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
// HitBTC markets (set to '' to disable) !!HITBTC WEBSOCKET API ONLY SUPPORTS ONE ASSET!!
exchange_markets['hitbtc'] = 'MYSTBTC';



// Maximum decimal places for coins worth under 1.00 unit value [btc/eth/usd/usdc/gbp/eur/whatever], for prettier / less-cluttered interface
var max_price_decimals = 7;



// Seconds between "slideshowing" multiple tickers (if multiple assets configured)
// SET TO ZERO FOR AUTO MODE (shows all configured tickers over 60 seconds)
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





