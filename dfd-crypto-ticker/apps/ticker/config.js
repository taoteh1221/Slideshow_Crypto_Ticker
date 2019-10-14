
// Copyright 2019 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com



//  TYPOS LIKE MISSED SEMICOLONS / MISSED QUOTES / ETC WILL BREAK THE APP, BE CAREFUL EDITING THIS CONFIG FILE



// What exchange to use
// Currently only coinbase is supported (kraken is coming soon)
var crypto_exchange = 'coinbase'; 



// Which crypto asset(s) to display on the ticker
// Separate with pipe | symbol to "slideshow" between multiple tickers (example:'BTC-USD|BTC-GBP|ETH-USD|ETH-BTC|ETH-EUR|LTC-BTC|LTC-EUR|MANA-USDC')
// BTC-USD / BTC-GBP / ETH-USD / ETH-BTC / ETH-EUR / LTC-BTC / LTC-EUR / MANA-USDC / whatever pairing available on the exchange
var crypto_markets = 'BTC-USD|ETH-USD|ETH-BTC'; 



// Seconds between "slideshowing" multiple tickers (if multiple assets configured)
var slideshow_speed = 20; 



// Title font size
var title_size = 59;



// Ticker font size
var ticker_size = 71;



// Volume font size
var volume_size = 37;



// Bottom margin (adjusts the ticker's vertical position)
var bottom_margin = 40;



// Screen orientation (upright, or flip upside-down)
var orient_screen = 'flip'; // 'upright' or 'flip'



// Use a google font...set as null for default system serif font
// Runs the ticker in ANY google font found at: https://fonts.google.com/
var google_font = 'Patua One'; // 'fontname' IN QUOTES for ANY google font, or null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)



// EMULATED / dynamic monospace font WIDTH spacing (percent of font HEIGHT as a decimal) 
// (ALL font widths for ticker/volume numbers are emulated as monospace, 
// so numbers don't "jump around" when changing in real-time)
// Set as null to skip monospace emulation 
var monospace_width = 0.65; // decimal number format X.XX of 1.00 or less, or null to skip (null MUST BE LOWERCASE WITHOUT QUOTES)





