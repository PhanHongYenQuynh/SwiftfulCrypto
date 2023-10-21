//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0){
            leftColumn
            Spacer()
            if showHoldingsColumn{centerColumn}
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
        
    }
}

struct CoinRowView_Previews: PreviewProvider{
    static var previews: some View{
        Group{
            CoinRowView(coin: dev.coin,showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin,showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
        
    }
}
// MARK: - EXTENSION
extension CoinRowView{
    
    private var leftColumn: some View{
        HStack(spacing:0)
        {
            Text("\(coin.rank)")
            .font(.caption)
            .foregroundColor(Color.theme.secondaryText)
            .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            Text(coin.symbol.uppercased())
            .font(.headline)
            .padding(.leading)
            .foregroundColor(Color.theme.accent)
        }
        
    }
    
    private var centerColumn: some View{
        VStack(alignment: .trailing)
        {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
            .bold()
            Text((coin.currentHoldings ?? 0)
                .asNumberString())
            
        }
        .foregroundColor(
            Color.theme.accent
        )
    }
    
    private var rightColumn: some View{
        VStack(
            alignment: .trailing
        ){
            Text(coin.currentPrice.asCurrencyWith2Decimals())
            .bold()
            .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? ""
            )
            .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ?Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width/3.5,
               alignment: .trailing
        )
    }
    
}


