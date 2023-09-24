//
//  XMarButton.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 24/09/2023.
//

import SwiftUI

struct XMarButton: View {
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
           dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XMarButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarButton()
    }

}
