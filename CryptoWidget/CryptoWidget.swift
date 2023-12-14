//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Phan Hong Yen Quynh on 14/12/2023.
//

import WidgetKit
import SwiftUI
import Charts


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Crypto {
        Crypto(symbol: "DefaultSymbol", name: "DefaultName", image: "DefaultImage", date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (Crypto) -> ()) {
        let entry = Crypto(symbol: "DefaultSymbol", name: "DefaultName", image: "DefaultImage", date: Date())
            completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Creating TimeLine Which will be updated for every 15 Minutes
        let currentDate = Date()
        // Since JSON Parsing using Async
        Task{
            if var cryptoData = try? await fetchData(){
                cryptoData.date = currentDate
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                let timeline = Timeline(entries: [cryptoData], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
    
    // MARK: - Fetching JSON Data
    func fetchData()async throws->Crypto{
        let session = URLSession(configuration: .default)
        let response = try await session.data(from: URL(string: APIURL)!)
        let cryptoData = try JSONDecoder().decode([Crypto].self, from: response.0)
        if let crypto = cryptoData.first{
            return crypto
        }
        return Crypto(symbol: "DefaultSymbol", name: "DefaultName", image: "DefaultImage")
    }
}

// MARK: - LIVE Crypto Data Using JSON API
fileprivate let APIURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en&precision=full"

// MARK: - Crypto JSON Model
struct Crypto: TimelineEntry, Codable {
    var symbol, name, image: String
    var date: Date = .init()
    var priceChange: Double = 0.0
    var currentPrice: Double = 0.0
    var last7Days: SparklineData = .init()
    
    enum CodingKeys: String, CodingKey {
        case symbol, name, image
        case priceChange = "price_change_percentage_24h_in_currency"
        case currentPrice = "current_price"
        case last7Days = "sparkline_in_7d"
    }
}

struct SparklineData: Codable{
    var price: [Double] = []
    
    enum CodingKeys: String, CodingKey{
        case price = "price"
    }
}


struct CryptoWidgetEntryView : View {
    var crypto: Provider.Entry
    // MARK: Use this Enviroment Property to find out the widget family
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        // Building Widget UI With Swift Charts
        if family == .systemMedium{
            MediumSizeWidget()
        }else{
            LockScreenWidget()
        }
    }
    
    @ViewBuilder
    func LockScreenWidget()-> some View{
        VStack(alignment: .leading){
            HStack{
                if let url = URL(string: crypto.image),
                   let imageData = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
                
            }
            
            VStack(alignment: .leading){
                Text(crypto.name)
                    .font(.callout)
                Text(crypto.symbol)
                    .font(.caption2)
            }
        }
        
        HStack{
            Text(crypto.currentPrice.toCurrency())
                .font(.callout)
                .fontWeight(.semibold)
            
            Text(crypto.priceChange.toString(floatingPoint: 1) + "%")
                .font(.caption2)
        }
    }
    
    
    @ViewBuilder
    func MediumSizeWidget()->some View{
        ZStack{
            VStack{
                HStack{
                    // Load image dynamically based on crypto.image
                    if let url = URL(string: crypto.image),
                       let imageData = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }

                    VStack(alignment: .leading){
                        Text(crypto.name)
                            .foregroundColor(.white)
                        
                        Text(crypto.symbol)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text(crypto.currentPrice.toCurrency())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 15){
                    VStack(spacing: 8){
                        Text("This week")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(crypto.priceChange.toString(floatingPoint: 1) + "%")
                            .fontWeight(.semibold)
                            .foregroundColor(crypto.priceChange < 0 ? .red : Color("GreenColor"))
                    }
                    
                    Chart{
                        let grapColor = crypto.priceChange < 0 ? Color.red : Color("GreenColor")
                        ForEach(crypto.last7Days.price.indices,id: \.self){index in
                            LineMark(x: .value("Hour", index), y: .value("Price", crypto.last7Days.price[index] - min()))
                                .foregroundStyle(grapColor)
                            //Giving Gradient background Effect
                            AreaMark(x: .value("Hour", index), y: .value("Price", crypto.last7Days.price[index] - min()))
                                .foregroundStyle(LinearGradient(colors: [
                                    grapColor.opacity(0.2),
                                    grapColor.opacity(0.1),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                }
            }
            .padding(.all)
        }
    }
    
    // MARK: - Finding Minimum Price Value and applying it to Graph so that it can draw from value 0.
    func min()->Double{
        if let min = crypto.last7Days.price.min(){
            return min
        }
        return 0.0
    }
}

struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"

    
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CryptoWidgetEntryView(crypto: entry)
                    .containerBackground(.black, for: .widget)
            } else {
                CryptoWidgetEntryView(crypto: entry)
                    .padding()
                    .background()
            }
        }
        // Configuring Widget Families
        // For Lock Screen Widget
        // Simply Add Accessory Type in the Widget Family
        
        .supportedFamilies([.systemMedium, .accessoryRectangular])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CryptoWidget_Previews: PreviewProvider{
    static var previews: some View{
        CryptoWidgetEntryView(crypto: Crypto(symbol: "PreviewSymbol", name: "PreviewName", image: "PreviewImage", date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

// MARK: - EXTENSIONS
extension Double{
    func toCurrency()->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? "$0.00"
    }
    
    func toString(floatingPoint: Int)->String{
        let string = String(format: "%.\(floatingPoint)f", self)
        return string
    }
}
