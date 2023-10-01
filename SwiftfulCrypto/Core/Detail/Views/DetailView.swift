//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 29/09/2023.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack{
            if let coin = coin{
                DetailView(coin: coin)
            }
        }
    }

}




struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    
    var body: some View {
        Text("hello")
    }
}

struct DetailView_Preview: PreviewProvider{
    static var previews: some View{
        DetailView(coin: dev.coin)
    }
 
}
