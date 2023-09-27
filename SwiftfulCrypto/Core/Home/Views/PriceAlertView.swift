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
    
 
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                   
                    Spacer()
                    Text("Coin")
                        .font(.title2)
                        .foregroundColor(Color.theme.accent)
                        .bold()
                    
                    TextField("Enter Target Price", text: $targetPrice)
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
                                
                            }) {
                                Text(percentage)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.green))
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
                            // Create a PriceAlertEntity and save it to CoreData
                            let targetPrice = Double(targetPrice) ?? 0
                            // Find the CoinModel associated with the selected coin ID
                                if let selectedCoin = vm.allCoins.first(where: { $0.id == vm.selectedCoinID }) {
                                    vm.priceAlertDataService.addPriceAlert(coin: selectedCoin, targetPrice: targetPrice, notificationEnabled: notificationEnabled)
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
}

struct PriceAlertView_Previews: PreviewProvider {
    static var previews: some View {
        PriceAlertView()
        
    }
}
