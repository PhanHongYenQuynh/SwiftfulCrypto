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
    
    // Save the current badge value
    @Published var badgeValue: Int = 0
    
    // Variable to track whether a notification is being presented
    @Published var isNotificationPresented: Bool = false

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
        
        // Đặt giá trị badgeValue về 0 khi người dùng mở thông báo
        badgeValue = 0
        isNotificationPresented = true // Set flag to indicate that a notification is being presented
        
        // Gọi completionHandler khi bạn đã xử lý xong sự kiện
        completionHandler()
    }
    
    func scheduleNotification(coin: CoinModel) {
        let content = UNMutableNotificationContent()
        content.title = "\(coin.name) Price Alert!"
        content.subtitle = "\(coin.symbol.uppercased()) price has increased. Check it out!"
        content.sound = .default
        
        
        // Tăng giá trị badgeValue khi có thông báo mới
//        badgeValue += 1
//        content.badge = NSNumber(value: badgeValue)

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
        isNotificationPresented = false
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Check if a notification is being presented and reset badgeValue if true
            if notificationManager.isNotificationPresented {
                UIApplication.shared.applicationIconBadgeNumber = 0
                notificationManager.isNotificationPresented = false
            }else {
                // Decrease badgeValue when a new notification is viewed
                notificationManager.badgeValue -= 1
                UIApplication.shared.applicationIconBadgeNumber = max(0, notificationManager.badgeValue)
            }
        }

    }
}

struct LocalNotification_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotification()
    }
}
