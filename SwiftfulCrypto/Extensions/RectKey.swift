//
//  RectKey.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 05/10/2023.
//

import SwiftUI

struct RectKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect){
        value = nextValue()
    }
}
