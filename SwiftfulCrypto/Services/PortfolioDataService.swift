//
//  PortfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 25/09/2023.
//

import Foundation
import CoreData
import FirebaseAuth

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    let notificationManager = NotificationManager()
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            
            // Fetch the user ID from Firebase and then get the portfolio
            if let userID = Auth.auth().currentUser?.uid {
                self.getPortfolio(for: userID)
            }
        }
    }
    
    // MARK: - PUBLIC
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // Check if user is logged in
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            return
        }
        
        // Check if coin is already in the portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount, userID: userID)
        }
    }
    
    
    func deletePortfolio(coinID: String) {
        if let entity = savedEntities.first(where: { $0.coinID == coinID }) {
            container.viewContext.delete(entity)
            applyChanges()
        }
    }
    
    
    // MARK: - PRIVATE
    private func getPortfolio(for userID: String) {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        request.predicate = NSPredicate(format: "userID == %@", userID)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double, userID: String) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        entity.userID = userID
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        // Fetch the user ID from Firebase and then get the portfolio
        if let userID = Auth.auth().currentUser?.uid {
            getPortfolio(for: userID)
        }
    }
}

