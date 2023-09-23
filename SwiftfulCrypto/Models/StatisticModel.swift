//
//  StatisticModel.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 23/09/2023.
//

import Foundation

struct StatisticModel: Identifiable{
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}


