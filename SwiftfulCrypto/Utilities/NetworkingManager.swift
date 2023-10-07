//
//  NetworkingManager.swift
//  SwiftfulCrypto
//
//  Created by Phan Hong Yen Quynh on 22/09/2023.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkingError: LocalizedError{
        case badURLReponse(url: URL)
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badURLReponse(url: let url): return "[🔥] Bad reponse from URL: \(url)"
            case.unknown: return "[⚠️] Uknow error occured"
            }
        }
    } 
    
    static func download(url: URL)-> AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output:$0, url: url)})
            .retry(3)
            .eraseToAnyPublisher()
        
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let reponse = output.response as? HTTPURLResponse,
              reponse.statusCode >= 200 && reponse.statusCode < 300 else{
            throw NetworkingError.badURLReponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
