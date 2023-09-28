//
//  PriceAlertView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 27/09/2023.
//

import SwiftUI
import UserNotifications


enum PriceAlertModel: String, CaseIterable {
    case once = "Once"
    case recurring = "Recurring"
}

struct PriceAlertView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var coinID: String = ""
    @State private var targetPrice: String = ""
    @State private var notificationEnabled: Bool = false
    @State private var alertModel: PriceAlertModel = .once // Default to "Once"
    @State private var selectedPercentage: Double = 0.0
    
    // Khai báo biến để lưu trữ phần trăm được chọn
    @State private var selectedPercentageText: String = "0%"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Spacer()
                    Text("Coin")
                        .font(.title2)
                        .foregroundColor(Color.theme.accent)
                        .bold()
                    
                    TextField("Enter Price", text: $targetPrice)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.theme.green, lineWidth: 1)
                        )
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    
                    Spacer()
                    Text("Target Price")
                        .font(.title2)
                        .foregroundColor(Color.theme.accent)
                        .bold()
                    
                    Spacer()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(["-20%", "-10%", "-5%", "+5%", "+10%", "+20%"], id: \.self) { percentage in
                            Button(action: {
                                /* Handle percentage button tap */
                                handlePercentageButtonTap(percentage)
                            }) {
                                Text(percentage)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedPercentageText == percentage ? Color.green : Color.clear)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.theme.green, lineWidth: selectedPercentageText == percentage ? 0 : 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    Text("Alert Mode")
                        .font(.title2)
                        .foregroundColor(Color.theme.accent)
                        .bold()
                    
                    Picker("Alert Model", selection: $alertModel) {
                        ForEach(PriceAlertModel.allCases, id: \.self) { model in
                            Text(model.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Spacer()
                    
                    // Center-align the "Save" button
                    HStack {
                        Spacer()
                        Button(action: {
                            let percentageMultiplier = 1 + (selectedPercentage / 100)
                            if let currentPrice = Double(targetPrice), let selectedCoin = vm.allCoins.first(where: { $0.id == vm.selectedCoinID }) {
                                let newTargetPrice = currentPrice * percentageMultiplier
                                targetPrice = String(format: "%.2f", newTargetPrice) // Cập nhật targetPrice
                                
                                // Create a PriceAlertEntity and save it to CoreData
                                vm.priceAlertDataService.addPriceAlert(coin: selectedCoin, targetPrice: newTargetPrice, notificationEnabled: notificationEnabled)
                                
                                // Lên lịch thông báo nếu notificationEnabled là true
                                if notificationEnabled {
                                    schedulePriceAlertNotification(coin: selectedCoin, targetPrice: newTargetPrice, alertModel: alertModel)
                                }
                                // Dismiss the view
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Save")
                                .padding(.horizontal, 70)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.pink))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Price Alert")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarButton(dismiss: _dismiss)
                    
                }
            })
        }
    }
    
       func schedulePriceAlertNotification(coin: CoinModel, targetPrice: Double, alertModel: PriceAlertModel) {
           let center = UNUserNotificationCenter.current()
           center.getNotificationSettings { settings in
               if settings.authorizationStatus == .authorized {
                   // Xác định thời điểm thông báo
                   let content = UNMutableNotificationContent()
                   content.title = "Price Alert"
                   content.body = "The price of \(coin.name) has reached \(targetPrice)"
                   
                   let trigger: UNNotificationTrigger
                   switch alertModel {
                   case .once:
                       trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false) // Thông báo ngay lập tức
                   case .recurring:
                       trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true) // Thông báo hàng giờ
                   }
                   
                   let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                   center.add(request)
               }
           }
       }
       
    func handlePercentageButtonTap(_ percentage: String) {
        selectedPercentageText = percentage
        if let selectedPercentage = Double(percentage.replacingOccurrences(of: "%", with: "")) {
            let currentPrice = Double(targetPrice) ?? 0.0
            let newTargetPrice = currentPrice * (1 + selectedPercentage / 100)
            targetPrice = String(format: "%.2f", newTargetPrice)
        }
    }
}

struct PriceAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertView()
        
    }
}

