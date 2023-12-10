//
//  SettingView.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 21/09/2023.
//

import SwiftUI


struct LanguageModifier: ViewModifier {
    @Environment(\.locale) private var locale
    @EnvironmentObject private var languageManager: LanguageManager
    
    
    func body(content: Content) -> some View {
        let modifiedContent = content.environment(\.locale, .init(identifier: languageManager.selectedLanguage.code))
        
        // Print a message whenever the language changes
        print("Language changed to: \(languageManager.selectedLanguage.rawValue)")
        
        return modifiedContent
    }
}


struct SettingView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var Email = ""
    @State private var Password = ""
    
    // Interface Style
    @State private var buttonRect: CGRect = .zero
    @StateObject private var appSettings = AppSettings()
    
    // Current & Previous State Images
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    @State private var maskAnimation: Bool = false
    
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var notificationManager = NotificationManager()
    @AppStorage("enableNotifications") private var enableNotifications = false

    @State private var isContactUsActive = false
    @State private var selectedCoin: CoinModel?
    
    let privacyPolicy = URL(string: "https://www.coingecko.com/en/privacy")!
    let termsofService = URL(string: "https://www.coingecko.com/en/terms")!
    let disclaimer = URL(string: "https://www.coingecko.com/en/disclaimer")!
    
    let twitter = URL(string: "https://twitter.com/coingecko")!
    let instagram = URL(string: "https://www.instagram.com/coingecko/")!
    let discord = URL(string: "https://discord.com/invite/EhrkaCH")!
    let telegram = URL(string: "https://t.me/coingecko")!
    
    let imageName: String
    let title: String
    let tintColor: Color
    
// MARK: - BODY
    var body: some View {
        NavigationView {
            List{
                myaccount
                appsettings
                enjoyUsingCrypto
                orthers
                general
                signout
            }
            .listStyle(SidebarListStyle())
            .font(.headline)
            .accentColor(.accent)
            .navigationTitle("Settings")
            .modifier(LanguageModifier())
            .environmentObject(languageManager)
        }
        .navigationViewStyle(StackNavigationViewStyle())

//MARK: - DARKMODE
        .createImages(
            toggleDarkMode: appSettings.toggleDarkMode,
            currentImage: $currentImage,
            previousImage: $previousImage,
            activateDarkMode: appSettings.$activateDarkMode)
        .overlay(content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                if let previousImage, let currentImage{
                    ZStack{
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading){
                                Circle()
                                    .frame(width: buttonRect.width * (maskAnimation ? 80 : 1), height: buttonRect.height * (maskAnimation ? 80 : 1), alignment: .bottomLeading)
                                    .frame(width: buttonRect.width, height: buttonRect.height)
                                    .offset(x: buttonRect.minX, y: buttonRect.minY)
                                    .ignoresSafeArea()
                            }
                    }
                    .task {
                        guard !maskAnimation else { return }
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete){
                            maskAnimation = true
                        }completion: {
                            // Removing all snapshots
                            self.currentImage = nil
                            self.previousImage = nil
                            maskAnimation = false
                        }
                    }
                }
            })
            // Reverse Masking
            .mask({
                Rectangle()
                    .overlay(alignment: .topLeading){
                        Circle()
                            .frame(width: buttonRect.width, height: buttonRect.height)
                            .offset(x: buttonRect.minX, y: buttonRect.minY)
                            .blendMode(.destinationOut)
                    }
            })
            .ignoresSafeArea()
        })
        .overlay(alignment: .topTrailing){
            Button(action: {
                appSettings.toggleDarkMode.toggle()
            }, label: {
                Image(systemName: appSettings.toggleDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.title2)
                    .foregroundStyle(Color.primary)
                    .symbolEffect(.bounce, value: appSettings.toggleDarkMode)
                    .frame(width: 40, height: 40)
            })
            .rect{ rect in
                buttonRect = rect
            }
            .padding(10)
            .disabled(currentImage != nil || previousImage != nil || maskAnimation)
        }
        .preferredColorScheme(appSettings.activateDarkMode ? .dark : .light)
        .background(
            NavigationLink(
                    destination: ContactUsView(),
                    isActive: $isContactUsActive,
                    label: { EmptyView() }
            )
        )
    }
}

// MARK: - PREVIEW
struct SettingView_Preview: PreviewProvider{
    static var previews: some View{
        SettingView(imageName: "gear", title: "Version", tintColor: Color(.accent))
            .environmentObject(AuthViewModel())
    }
}

// MARK: - EXTENSION
extension SettingView{
    private var myaccount: some View{
        Section(header: Text("My Account")){
            if let user = viewModel.currentUser {
                HStack{
                    Text(user.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(user.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text(user.email)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }else {
                // Handle the case when currentUser is nil (not logged in)
                // You might want to show a login button or other UI in this case.
                Text("Unknow 🤔")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var appsettings: some View {
        Section(header: Text("App Settings")) {
            Toggle("Notification", isOn: $enableNotifications)
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .onChange(of: enableNotifications) { newValue in
                    if newValue {
                        notificationManager.requestAuthorization()
                        // Ensure 'selectedCoin' is set to the desired CoinModel
                        guard let selectedCoin = selectedCoin else {
                            // Handle the case when no coin is selected
                            return
                        }
                        notificationManager.scheduleNotification(coin: selectedCoin)
                    } else {
                        notificationManager.cancelNotification()
                    }
                }

            Picker("Language", selection: $languageManager.selectedLanguage) {
                ForEach(Language.allCases, id: \.self) { language in
                    Text(language.localizedString)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: languageManager.selectedLanguage) { _ in
                // Call the function to handle language changes
                languageManager.changeLanguage(languageManager.selectedLanguage)
            }
        }
    }


    
    private var orthers: some View{
        Section(header: Text("Others")){
            Link("Privacy Policy", destination: privacyPolicy)
            Link("Terms of Service", destination: termsofService)
            Link("Disclaimer", destination: disclaimer)
        }
        
    }
    
    private var enjoyUsingCrypto: some View {
        Section(header: Text("Enjoy using Crypto Tracker")) {
            Link(destination: twitter) {
                HStack {
                    Image("twitter")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Follow us on Twitter")
                }
            }

            Link(destination: instagram) {
                HStack {
                    Image("instagram")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Follow us on Instagram")
                }
            }

            Link(destination: discord) {
                HStack {
                    Image("discord")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Join our Discord server")
                }
            }

            Link(destination: telegram) {
                HStack {
                    Image("telegram")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Join our Telegram group")
                }
            }

            Link(destination: disclaimer) {
                HStack {
                    Image("appstore")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Rate the CryptoTracker App")
                }
            }

            Button(action: {
                isContactUsActive = true
            }) {
                HStack {
                    Image("gmail")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(NSLocalizedString("Contact us", comment: ""))
                }
            }
        }
    }
    
    private var general: some View{
        Section(header: Text("General")){
            HStack(spacing: 12){
                Image(systemName: imageName)
                    .imageScale(.small)
                    .font(.title)
                    .foregroundColor(tintColor)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.accent)
                
                Spacer()
                Text("1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            
            Button(action: {
                // Call the delete account function
                Task {
                    await viewModel.deleteAccount()
                }
            }) {
                HStack(spacing: 12){
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.small)
                        .font(.title)
                        .foregroundColor(.red)
                    
                    Text("Delete Account")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private var signout: some View{
        Section {
            Button(action: {
                viewModel.signOut()
            }) {
                Text("SIGN OUT")
                    .font(.title3)
                    .foregroundColor(.steel)
                    .fontWeight(.semibold)
            }
            
            .frame(maxWidth: .infinity, maxHeight: 10)
            .padding()
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .background(Color.theme.accent)
        
    }
    
}

