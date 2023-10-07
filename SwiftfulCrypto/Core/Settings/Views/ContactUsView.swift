//
//  ContactUsView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 07/10/2023.
//

import SwiftUI

struct ContactUsView: View {
    
    let faq = URL(string: "https://www.coingecko.com//faq")!
    
    var body: some View {
        NavigationView {
            List{
                Image("faq")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .clipped()
                    .padding()
                contactUs
            }
            .navigationTitle(NSLocalizedString("Contact us", comment: ""))
        }
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}

extension ContactUsView{
    private var contactUs: some View{
        Section(header: Text(NSLocalizedString("Contact us", comment: "")))  {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(NSLocalizedString("Email:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text("hello@cryptotracker.com")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text(NSLocalizedString("Phone:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text("+1(559) 742 4592")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text(NSLocalizedString("FAQ:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Link("https://www.coingecko.com/faq", destination: faq)
                        .font(.callout)
                        .foregroundColor(.blue)
                }
            }
            
        }
    }
}
