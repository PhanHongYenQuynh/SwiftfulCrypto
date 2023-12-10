//
//  LocalNotification.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/11/2023.
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let instance = NotificationManager() // Singleton
   
    // Save the current price of the coin
    var currentPrice: Double?

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Xử lý sự kiện khi người dùng bấm vào thông báo ở đây
        // Ở đây bạn có thể thực hiện các hành động cụ thể, chẳng hạn như mở một màn hình cụ thể
        // ...
        
        // Xoá tất cả thông báo đã được hiển thị
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        // Gọi completionHandler khi bạn đã xử lý xong sự kiện
        completionHandler()
    }
    
    func scheduleNotification(coin: CoinModel) {
        let content = UNMutableNotificationContent()
        content.title = "\(coin.name) Price Alert!"
        content.subtitle = "\(coin.symbol.uppercased()) price has increased. Check it out!"
        content.sound = .default
        content.badge = 1

        // Thiết lập thời gian thông báo (ví dụ: sau 5 giây)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        // Đặt đối tượng delegate cho UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
        
        // Đăng ký thông báo
        UNUserNotificationCenter.current().add(request)
    }
        
    
    // Function to check and send notifications when the price changes
    func checkAndSendNotification(newPrice: Double, coin: CoinModel) {
        guard let currentPrice = currentPrice else {
            // If the current price is not available, save the new price and exit
            self.currentPrice = newPrice
            return
        }

        // Check for price changes
        let priceChange = newPrice - currentPrice
        let percentageChange = (priceChange / currentPrice) * 100

        // If the price changes, send a notification
        if abs(percentageChange) >= 1.0 {
            scheduleNotification(coin: coin)
        }

        // Save the new price
        self.currentPrice = newPrice
    }
    
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

struct LocalNotification: View {
    @StateObject private var notificationManager = NotificationManager()
    @State private var selectedCoin: CoinModel?
    
    var body: some View {
        VStack(spacing: 40) {
            Button("Request permission") {
                notificationManager.requestAuthorization()
            }
            Button("Schedule notification") {
                // Make sure 'selectedCoin' is set to the desired CoinModel
                guard let selectedCoin = selectedCoin else {
                    // Handle the case when no coin is selected
                    return
                }
                notificationManager.scheduleNotification(coin: selectedCoin)
            }
            
            Button("Cancel notification") {
                notificationManager.cancelNotification()
            }
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

struct LocalNotification_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotification()
    }
}
