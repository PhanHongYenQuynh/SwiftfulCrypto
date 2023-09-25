//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 24/09/2023.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    
  
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                   
                    if selectedCoin != nil{
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarButton(dismiss: _dismiss)
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == ""{
                    removeSelectedCoin()
                }
            })
            
        }
    }
}

struct PortfolioView_Previews: PreviewProvider{
 
    static var previews: some View{
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView{
    private var coinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: true, content:{
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id}),
            let amount = portfolioCoin.currentHoldings{
            quantityText = "\(amount)"
        }else{
            quantityText = ""
        }
    }
    
    
    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding: ")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(nil, value: selectedCoin?.id)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some View{
        HStack(spacing: 10){
           
            Button(action: {
                saveButtonPressed()
                
            }, label: {
                Text("Save".uppercased())
            })
            .disabled(!(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)))
        
        }
        .font(.headline)
    }
    
    private func saveButtonPressed(){
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else{ return }
        
        //save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        
        
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
    
}
