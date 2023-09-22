//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 22/09/2023.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
