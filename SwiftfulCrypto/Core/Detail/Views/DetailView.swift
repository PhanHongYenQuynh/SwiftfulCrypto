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
    
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20){
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection

                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                navigationBarTrallingItems
            }
        }
    }
}

struct DetailView_Preview: PreviewProvider{
    static var previews: some View{
        NavigationView{
            DetailView(coin: dev.coin)
        }
    }
 
}

// MARK: - EXTENSION
extension DetailView{
    
    private var navigationBarTrallingItems: some View{
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Addition Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty{
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button(action:{
                        withAnimation(.easeOut){
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(NSLocalizedString(showFullDescription ? "Less" : "Read more..", comment: "Read more button text"))
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
               
            }
        }
        
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics){ stat in
                    StatisticView(stat: stat)
                }
        })
        
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics){ stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let websiteString = vm.websiteURL, let websiteURL = URL(string: websiteString) {
                Link(destination: websiteURL) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(Color.theme.accent)
                            .imageScale(.medium)
                        Text("Homepage")
                            .font(.headline)
                            .foregroundColor(Color.theme.secondaryText)
                            .lineLimit(1)
                        Spacer()
                        Text(" \(websiteString)")
                            .font(.headline)
                            .foregroundColor(.green)
                            .lineLimit(1)
                    }
                    .padding(10)
                }
            }

            Divider().background(Color.gray)

            if let redditString = vm.redditURL, let redditURL = URL(string: redditString) {
                Link(destination: redditURL) {
                    HStack {
                        Image(systemName: "r.circle")
                            .foregroundColor(Color.theme.accent)
                            .imageScale(.medium)
                        Text("Reddit")
                            .font(.headline)
                            .foregroundColor(Color.theme.secondaryText)
                            .lineLimit(1)
                        Spacer()
                        Text(" \(redditString)")
                            .font(.headline)
                            .foregroundColor(.green)
                            .lineLimit(1)
                    }
                    .padding(10)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accentColor(.blue)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.4), radius: 5, x: 0, y: 2)
        )
    }
}
