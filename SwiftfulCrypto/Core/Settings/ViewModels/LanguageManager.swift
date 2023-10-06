//
//  LanguageManager.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 06/10/2023.
//

import Foundation
import Combine

enum Language: String, CaseIterable {
    case english, vietnamese

    var code: String {
        switch self {
        case .english: return "en"
        case .vietnamese: return "vi"
        }
    }
    
    static var selected: Language {
        set {
            UserDefaults.standard.set([newValue.code], forKey: "AppleLanguages")
            UserDefaults.standard.set(newValue.rawValue, forKey: "language")
        }
        get {
            Language(rawValue: UserDefaults.standard.string(forKey: "language") ?? "") ?? .english
        }
    }
}

class LanguageManager: ObservableObject {
    @Published var selectedLanguage = Language.english 
    @Published var languageChanged = false
    
    func changeLanguage(_ language: Language) {
            Language.selected = language
            UserDefaults.standard.set(language.rawValue, forKey: "language") // Save immediately
            languageChanged = true
            objectWillChange.send()
    }

    init() {
        // Load the selected language from UserDefaults
        selectedLanguage = Language.selected
    }
}
