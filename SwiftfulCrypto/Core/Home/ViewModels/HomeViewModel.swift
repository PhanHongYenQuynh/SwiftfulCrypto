//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allcoins
            .sink{[weak self] (returnedCoins)
                in self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    
}
