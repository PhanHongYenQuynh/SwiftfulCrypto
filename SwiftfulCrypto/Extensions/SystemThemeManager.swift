//
//  SystemThemeManager.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 04/10/2023.
//

import Foundation
import UIKit

class SystemThemeManager{
    
    static let shared = SystemThemeManager()
    
    private init(){}
    
    func handleTheme(darkMode: Bool){
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
}
