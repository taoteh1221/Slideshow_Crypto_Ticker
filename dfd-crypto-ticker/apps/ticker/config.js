
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
var title_size = 52;


// Ticker font size
var ticker_size = 72;


// Volume font size
var volume_size = 35;


// Bottom margin (adjusts the ticker's vertical position)
var bottom_margin = 43;


// Screen orientation (upright, or flip upside-down)
var orient_screen = 'flip'; // 'upright' or 'flip'




