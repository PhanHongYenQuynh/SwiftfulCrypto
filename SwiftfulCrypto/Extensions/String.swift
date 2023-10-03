//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 04/10/2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
