//
//  PriceAlertDataService.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 27/09/2023.
//

import Foundation
import CoreData
import Combine

class PriceAlertDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PriceAlertContainer"
    private let entityName: String = "PriceAlertEntity"
    private var cancellables = Set<AnyCancellable>()
    
    @Published var priceAlerts: [PriceAlertEntity] = []
    
    init() {
            container = NSPersistentContainer(name: containerName)
            container.loadPersistentStores { (_, error) in
                if let error = error {
                    print("Error loading Core Data! \(error)")
                }
                self.getPriceAlerts()
            }
        
        
        }
    
    // MARK: PUBLIC
        
        func addPriceAlert(coin: CoinModel, targetPrice: Double, notificationEnabled: Bool) {
            let entity = PriceAlertEntity(context: container.viewContext)
            entity.coinID = coin.id
            entity.targetPrice = targetPrice
            entity.notificationEnabled = notificationEnabled
            applyChanges()
        }
        
        func deletePriceAlert(coinID: String) {
            if let entity = priceAlerts.first(where: { $0.coinID == coinID }) {
                container.viewContext.delete(entity)
                applyChanges()
            }
        }
        
        // MARK: PRIVATE
        
        private func getPriceAlerts() {
            let request = NSFetchRequest<PriceAlertEntity>(entityName: entityName)
            do {
                priceAlerts = try container.viewContext.fetch(request)
            } catch let error {
                print("Error fetching Price Alert Entities. \(error)")
            }
        }
        
        private func applyChanges() {
            save()
            getPriceAlerts()
        }
        
        private func save() {
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving to Core Data. \(error)")
            }
        }
}
