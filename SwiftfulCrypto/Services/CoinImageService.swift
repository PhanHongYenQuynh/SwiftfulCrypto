//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 22/09/2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let filManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = filManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
        }else{
            downloadCoinImage()
        }
    }
    
    
    private func downloadCoinImage(){
        
        
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in return UIImage(data: data)})
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else{return}
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.filManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
}
