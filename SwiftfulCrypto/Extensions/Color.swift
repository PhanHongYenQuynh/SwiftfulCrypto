//
//  Color.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 20/09/2023.
//

import Foundation
import SwiftUI

extension Color{
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme{
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme{
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
