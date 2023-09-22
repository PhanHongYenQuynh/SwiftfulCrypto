//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack{
            // background layer
            Color.theme.background.ignoresSafeArea()
            
            //content layer
            VStack{
                
                homeHeader
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortfolio{
                    allCoinList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct HomeView_Preview:PreviewProvider {
    static var previews: some View{
        NavigationView{
            HomeView().navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
     
    }
  
}


extension HomeView{
    
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus":"info")
                .animation(.none, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180: 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View{
        List{
            ForEach(vm.allCoins){coin in CoinRowView(coin: coin, showHoldingsColumn: false).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
    private var portfolioCoinList: some View{
        List{
            ForEach(vm.portfolioCoins){coin in CoinRowView(coin: coin, showHoldingsColumn: true).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
    private var columnTitles: some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio{
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width/3.5,
                       alignment: .trailing
                )
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}


