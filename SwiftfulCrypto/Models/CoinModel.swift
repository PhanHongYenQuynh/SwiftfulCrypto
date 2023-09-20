//
//  CoinModel.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import Foundation

//CoinGecko API info
/*
 URL:
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en&precision=full
 
 JSON Response:
 {
         "id": "bitcoin",
         "symbol": "btc",
         "name": "Bitcoin",
         "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
         "current_price": 27111.54584272751,
         "market_cap": 528345504018,
         "market_cap_rank": 1,
         "fully_diluted_valuation": 569253321763,
         "total_volume": 14244494535,
         "high_24h": 27454,
         "low_24h": 26886,
         "price_change_24h": 225.43,
         "price_change_percentage_24h": 0.83847,
         "market_cap_change_24h": 4184176675,
         "market_cap_change_percentage_24h": 0.79826,
         "circulating_supply": 19490893,
         "total_supply": 21000000,
         "max_supply": 21000000,
         "ath": 69045,
         "ath_change_percentage": -60.74829,
         "ath_date": "2021-11-10T14:24:11.849Z",
         "atl": 67.81,
         "atl_change_percentage": 39867.04219,
         "atl_date": "2013-07-06T00:00:00.000Z",
         "roi": null,
         "last_updated": "2023-09-20T08:17:37.232Z",
         "sparkline_in_7d": {
             "price": [
                 25899.214193103733,
                 25950.63889586843,
                 25886.469496421727,
                 25942.732085181477,
                 26122.023893246413,
                 26105.761078248503,
                 26180.571209215264,
                 26186.539893484543,
                 26181.399852640352,
                 26188.39626073516,
                 26240.792627505187,
                 26304.01546518303,
                 26091.35049184821,
                 26133.33058838231,
                 26145.32151330617,
                 26226.862815769757,
                 26231.9493781631,
                 26234.18982796697,
                 26222.013303986474,
                 26488.966008361596,
                 26208.463348448524,
                 26249.26511882836,
                 26258.64482104317,
                 26213.568845517944,
                 26193.031945995655,
                 26289.032017713966,
                 26355.570038862013,
                 26293.175851265434,
                 26279.82107866277,
                 26298.857189095856,
                 26418.287932796033,
                 26479.29027258699,
                 26542.85915995021,
                 26751.79664567292,
                 26688.691714839948,
                 26583.251622460648,
                 26619.408529040997,
                 26601.043663052755,
                 26636.597761721252,
                 26576.923372009656,
                 26544.83468544189,
                 26615.532123428224,
                 26531.39556626326,
                 26529.77638373226,
                 26506.205835634933,
                 26599.794162700844,
                 26619.371827748,
                 26653.565743786352,
                 26591.2634436531,
                 26575.998948235687,
                 26569.22550324378,
                 26617.08907084948,
                 26641.97583856179,
                 26629.71436109239,
                 26479.808783650304,
                 26375.58083976395,
                 26441.25513890341,
                 26251.615685201057,
                 26320.506096171328,
                 26362.602910709724,
                 26367.061843983578,
                 26356.727827118706,
                 26427.542806322395,
                 26406.960131317344,
                 26466.627409553737,
                 26792.60882462043,
                 26610.403126161622,
                 26637.676118192823,
                 26663.714857986022,
                 26704.25388242849,
                 26624.316186014064,
                 26604.744367280226,
                 26546.000476745226,
                 26471.09371981062,
                 26489.853636572643,
                 26507.86894063841,
                 26542.28540876647,
                 26528.22877496949,
                 26530.132596770418,
                 26574.159426883907,
                 26547.033583330496,
                 26514.846146933192,
                 26532.029422507887,
                 26533.045434751308,
                 26577.13171683862,
                 26571.034961764737,
                 26534.773305412753,
                 26545.15123574602,
                 26576.697031424446,
                 26566.033844441456,
                 26557.768691994646,
                 26470.036122923164,
                 26510.475433966454,
                 26524.653127846243,
                 26535.20829753553,
                 26562.489915752496,
                 26545.0854242848,
                 26549.936474136273,
                 26494.729010798754,
                 26551.53028796057,
                 26574.740939582,
                 26605.36747233914,
                 26586.475348507603,
                 26583.778812580116,
                 26549.705841471747,
                 26572.60934792332,
                 26556.08429333667,
                 26523.239737958964,
                 26496.59086020322,
                 26501.904023273473,
                 26504.032756422563,
                 26462.58323203275,
                 26484.21067751066,
                 26468.617801591503,
                 26520.988254783886,
                 26505.771084799046,
                 26456.81769925053,
                 26676.032052943723,
                 26666.378790034138,
                 26623.769887126396,
                 26657.999330340524,
                 26660.428508364123,
                 26695.936788348576,
                 26707.637744803884,
                 26866.544703080435,
                 27128.867817693306,
                 27180.197194827022,
                 27394.588104693972,
                 27258.995949583415,
                 27265.78414303009,
                 27267.443496733686,
                 27266.969453656227,
                 26821.851065864783,
                 26719.579525357352,
                 26863.187669787494,
                 26787.33729318315,
                 26801.832482690246,
                 26867.0605755984,
                 26741.461110948952,
                 26682.841448803098,
                 26698.107813619576,
                 26779.1885428471,
                 26820.77736698705,
                 26864.929364500967,
                 26817.178714597805,
                 26828.934567385746,
                 26875.902968384416,
                 27052.095871968973,
                 27289.4248902988,
                 27183.994603047813,
                 27222.58191830418,
                 27145.730412737612,
                 27076.486393257255,
                 27143.212388822172,
                 27285.48143150427,
                 27278.936209801446,
                 27192.599824193756,
                 27113.69924015732,
                 27163.178091247963,
                 27178.37716757279,
                 27136.97284512376,
                 27200.83584839815,
                 27213.18465907596,
                 27173.66776619467,
                 27318.242557709546,
                 27161.87334289422,
                 27093.36215386263,
                 27149.351761098074
             ]
         },
         "price_change_percentage_24h_in_currency": 0.838468826204176
     }
 */

import Foundation

struct CoinModel: Identifiable, Codable{
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    private enum CodingKeys: String,CodingKey{
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel{
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: athChangePercentage, atlDate: athDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
        
    }
    
    var currentHoldingsValue: Double{
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int{
        return Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
