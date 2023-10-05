//
//  AppSettings.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 05/10/2023.
//

import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("activateDarkMode") var activateDarkMode: Bool = false
    @AppStorage("toggleDarkMode")  var toggleDarkMode: Bool = false
}

