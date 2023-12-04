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
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .clipped()
                    .padding()
                contactUs
                hutech
            }
            .listStyle(SidebarListStyle())
            .navigationTitle(NSLocalizedString("Contact us", comment: ""))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}

// MARK: - EXTENSION
extension ContactUsView{
    private var contactUs: some View{
        Section(header: Text(NSLocalizedString("Contact us", comment: "")))  {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(NSLocalizedString("Email:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text("phanquynh.devpro@gmail.com")
                        .font(.callout)
                }
                
                HStack {
                    Text(NSLocalizedString("Phone:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text("(028) 5445 7777")
                        .font(.callout)
                        .foregroundColor(.green)
                }

                HStack {
                    Text(NSLocalizedString("FAQ:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Link("https://www.hutech.edu.vn", destination: faq)
                        .font(.callout)
                }
            }
            
        }
    }
    private var hutech: some View{
        Section(header: Text("HUTECH")){
            VStack(alignment: .leading){
                Image("hutech")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This crypto tracking app is developed by Phan Hong Yen Quynh, a student at Hutech University of Technology. It's a specialized project filled with creativity and motivation.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
        }
    }
}
