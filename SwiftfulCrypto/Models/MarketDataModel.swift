//
//  MarketDataModel.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 23/09/2023.
//

import Foundation

//JSON data:
/*
 URL: https://api.coingecko.com/api/v3/global
 JSON Response:
 {
 "data": {
   "active_cryptocurrencies": 10100,
   "upcoming_icos": 0,
   "ongoing_icos": 49,
   "ended_icos": 3376,
   "markets": 868,
   "total_market_cap": {
     "btc": 41156297.43737854,
     "eth": 687182728.0859241,
     "ltc": 16871761533.412233,
     "bch": 5258466032.372193,
     "bnb": 5192075756.126175,
     "eos": 1901311972171.1194,
     "xrp": 2147963883532.7253,
     "xlm": 9627165964632.129,
     "link": 155572836968.4061,
     "dot": 272549972704.14362,
     "yfi": 211398482.6903692,
     "usd": 1093648005224.0359,
     "aed": 4016837885427.26,
     "ars": 382804143028543.3,
     "aud": 1697684015933.3389,
     "bdt": 119595813086042.23,
     "bhd": 412229836257.1029,
     "bmd": 1093648005224.0359,
     "brl": 5397699729783.2295,
     "cad": 1475604571048.5308,
     "chf": 991512218016.1637,
     "clp": 977940046271333.4,
     "cny": 7981005682922.921,
     "czk": 25069583858950.074,
     "dkk": 7657067143775.558,
     "eur": 1025568416898.8405,
     "gbp": 893576039148.3506,
     "hkd": 8552819542454.327,
     "huf": 399958011990482.3,
     "idr": 16795207098625780,
     "ils": 4163933542129.879,
     "inr": 90881438362913.9,
     "jpy": 162166126214620.12,
     "krw": 1460736426417509,
     "kwd": 337926297134.1748,
     "lkr": 353367005867259,
     "mmk": 2288527105778471.5,
     "mxn": 18825838032325.54,
     "myr": 5130849616508.585,
     "ngn": 836823822545422.4,
     "nok": 11790291049918.771,
     "nzd": 1835287901598.6335,
     "php": 62165688924243.5,
     "pkr": 320384183130381.5,
     "pln": 4728332468185.875,
     "rub": 105318314933202.95,
     "sar": 4102309757979.532,
     "sek": 12179848469379.562,
     "sgd": 1493813810335.5134,
     "thb": 39249806396316.83,
     "try": 29717369151551.184,
     "twd": 35165157959973.7,
     "uah": 40249133822978.35,
     "vef": 109506974763.08292,
     "vnd": 26654874924894428,
     "zar": 20510318435891.785,
     "xdr": 826371369227.3331,
     "xag": 46431525996.50995,
     "xau": 568007964.4732099,
     "bits": 41156297437378.54,
     "sats": 4115629743737854
   },
   "total_volume": {
     "btc": 916252.5113362066,
     "eth": 15298579.79361756,
     "ltc": 375611870.79998946,
     "bch": 117067933.89925624,
     "bnb": 115589903.53388445,
     "eos": 42328440064.02793,
     "xrp": 47819590806.02096,
     "xlm": 214327224298.2043,
     "link": 3463479745.350963,
     "dot": 6067712901.889564,
     "yfi": 4706312.3438747255,
     "usd": 24347616129.197212,
     "aed": 89425872328.60591,
     "ars": 8522274335622.258,
     "aud": 37795121036.36251,
     "bdt": 2662532125299.0117,
     "bhd": 9177371295.194475,
     "bmd": 24347616129.197212,
     "brl": 120167659405.65286,
     "cad": 32851021062.319347,
     "chf": 22073792258.891495,
     "clp": 21771638342728.16,
     "cny": 177679163464.4295,
     "czk": 558117969767.9752,
     "dkk": 170467399566.9612,
     "eur": 22831977025.154705,
     "gbp": 19893463234.52187,
     "hkd": 190409314557.5807,
     "huf": 8904166694608.717,
     "idr": 373907558276888,
     "ils": 92700626697.98264,
     "inr": 2023271074385.8025,
     "jpy": 3610264519637.3643,
     "krw": 32520015221042.887,
     "kwd": 7523169907.760646,
     "lkr": 7866922602594.907,
     "mmk": 50948915196295.305,
     "mxn": 419114994524.7757,
     "myr": 114226841070.12918,
     "ngn": 18630002616728.223,
     "nok": 262484345204.0366,
     "nzd": 40858562445.35426,
     "php": 1383979418519.13,
     "pkr": 7132634145048.327,
     "pln": 105265700953.77806,
     "rub": 2344675701065.474,
     "sar": 91328711571.95103,
     "sek": 271156966069.25638,
     "sgd": 33256408870.870533,
     "thb": 873808770937.288,
     "try": 661590468793.8376,
     "twd": 782873249018.2083,
     "uah": 896056551261.0393,
     "vef": 2437926803.0165215,
     "vnd": 593410914245803.1,
     "zar": 456616166791.60986,
     "xdr": 18397302223.38269,
     "xag": 1033693625.239394,
     "xau": 12645421.389021207,
     "bits": 916252511336.2065,
     "sats": 91625251133620.66
   },
   "market_cap_percentage": {
     "btc": 47.365062490523336,
     "eth": 17.49958980289603,
     "usdt": 7.602872958835283,
     "bnb": 2.962271781440487,
     "xrp": 2.4771989106945536,
     "usdc": 2.3552498395967674,
     "steth": 1.2687591503731446,
     "doge": 0.7938604578367647,
     "ada": 0.7861211444382111,
     "ton": 0.7368612191176784
   },
   "market_cap_change_percentage_24h_usd": -0.0023685292793253552,
   "updated_at": 1695476792
 }
}
 
 */


struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
   
    enum CodingKeys: String, CodingKey{
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String{
        
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String{
        
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominace: String{
        
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return item.value.asPercentString()
        }
        return ""
    }
    
}
