//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 25/09/2023.
//

import Foundation
import SwiftUI

class HapticManager{
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
