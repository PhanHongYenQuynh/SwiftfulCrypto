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
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var isShowingDeleteConfirmation = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @StateObject private var appSettings = AppSettings()
    
    var body: some View {
        ZStack{
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            //content layer
            VStack{
                
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortfolio{
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView()})
        )
        .background(
            NavigationLink(
                destination: SettingView()
                    .environmentObject(appSettings),
                isActive: $showSettingsView,
                label: { EmptyView() })
        )
        .preferredColorScheme(appSettings.activateDarkMode ? .dark : .light)
        
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
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
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
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins){coin in 
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinList: some View{
        List{
            ForEach(vm.portfolioCoins){coin in CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .swipeActions{
                        Button(role: .destructive){
                            //delete swpieActions
                            vm.deletePortfolio(coin: coin)
                        }label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                    .onTapGesture {
                        segue(coin: coin)
                    }
                
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    
    private var columnTitles: some View{
        HStack{
            HStack(spacing:4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
          
            Spacer()
            if showPortfolio{
                HStack(spacing:4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing:4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)){
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}


